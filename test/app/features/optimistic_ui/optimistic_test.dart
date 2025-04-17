import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/optimistic_ui/operation_manager.dart';
import 'package:ion/app/features/optimistic_ui/optimistic_model.dart';

class TestModel implements OptimisticModel {
  TestModel(this.optimisticId, this.value);
  @override
  final String optimisticId;
  final String value;

  @override
  bool equals(Object other) =>
      other is TestModel && optimisticId == other.optimisticId && value == other.value;

  @override
  String toString() => '[$optimisticId:$value]';
}

void main() {
  group('OptimisticOperationManager – extended coverage', () {
    late OptimisticOperationManager<TestModel> mgr;
    late List<List<TestModel>> emissions;
    late StreamSubscription<List<TestModel>> sub;

    setUp(() => emissions = []);

    tearDown(() async {
      await sub.cancel();
    });

    /// helper
    StreamSubscription<List<TestModel>> listen() =>
        mgr.stream.listen((e) => emissions.add(List.of(e)));

    test('optimistic emission happens before syncCallback completes', () async {
      final optimisticEmitted = Completer<void>();

      mgr = OptimisticOperationManager<TestModel>(
        syncCallback: (p, o) async {
          // Wait until UI publishes the optimistic state
          await optimisticEmitted.future;
          return o;
        },
        onError: (_, __) async => false,
      );

      sub = listen();
      mgr.initialize([TestModel('1', 'A')]);

      // Complete the completer when we get the second emission (optimistic)
      sub.onData((state) {
        emissions.add(List.of(state));
        if (emissions.length == 2 && !optimisticEmitted.isCompleted) {
          optimisticEmitted.complete();
        }
      });

      await mgr.perform(
        previous: TestModel('1', 'A'),
        optimistic: TestModel('1', 'B'),
      );

      // Wait for the optimistic emission
      await optimisticEmitted.future;

      expect(emissions.length, equals(2)); // initial + optimistic
      expect(emissions.last.single.value, 'B'); // optimistic value
    });

    test('server stale triggers exactly one follow‑up sync', () async {
      var attempts = 0;
      mgr = OptimisticOperationManager<TestModel>(
        syncCallback: (p, o) async {
          attempts++;
          // server is outdated – returns B when UI moved to C
          return TestModel(o.optimisticId, 'B');
        },
        onError: (_, __) async => false,
      );

      sub = listen();
      mgr.initialize([TestModel('1', 'A')]);

      await mgr.perform(
        previous: TestModel('1', 'A'),
        optimistic: TestModel('1', 'C'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(attempts, equals(2), reason: 'should have follow‑up request');
      expect(emissions.last.single.value, equals('B'));
    });

    test('maxRetries limits attempts and rolls back state', () async {
      var attempts = 0;
      mgr = OptimisticOperationManager<TestModel>(
        maxRetries: 2,
        syncCallback: (_, __) async {
          attempts++;
          throw Exception('permanent');
        },
        onError: (_, __) async => true, // always try to retry
      );

      sub = listen();
      final initial = TestModel('1', 'A');
      mgr.initialize([initial]);

      await mgr.perform(
        previous: initial,
        optimistic: TestModel('1', 'B'),
      );

      // 1 (init) + 2 retries + check >2 not executed
      await Future<void>.delayed(const Duration(seconds: 1));

      expect(attempts, equals(3)); // initial try + 2 retries
      expect(
        emissions.last.single.value,
        equals('A'),
        reason: 'should roll back to the initial state',
      );
    });

    test('parallel operations on different ids resolve correctly', () async {
      var attempts = 0;
      mgr = OptimisticOperationManager<TestModel>(
        syncCallback: (p, o) async {
          attempts++;
          return o;
        },
        onError: (_, __) async => false,
      );

      sub = listen();
      mgr.initialize([
        TestModel('1', 'A'),
        TestModel('2', 'X'),
      ]);

      await mgr.perform(
        previous: TestModel('1', 'A'),
        optimistic: TestModel('1', 'B'),
      );
      await mgr.perform(
        previous: TestModel('2', 'X'),
        optimistic: TestModel('2', 'Y'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 200));

      final state = emissions.last;
      expect(
        state.firstWhere((e) => e.optimisticId == '1').value,
        equals('B'),
      );
      expect(
        state.firstWhere((e) => e.optimisticId == '2').value,
        equals('Y'),
      );
      expect(attempts, equals(2));
    });

    test('dispose closes stream and prevents further emissions', () async {
      mgr = OptimisticOperationManager<TestModel>(
        syncCallback: (p, o) async => o,
        onError: (_, __) async => false,
      );

      sub = listen();
      mgr
        ..initialize([TestModel('1', 'A')])
        ..dispose();

      // attempt after dispose
      expect(
        () async {
          await mgr.perform(
            previous: TestModel('1', 'A'),
            optimistic: TestModel('1', 'B'),
          );
        },
        throwsA(isA<StateError>()),
      ); // StreamController closed
    });
  });
}
