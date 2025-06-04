import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/utils/queue.dart';

void main() {
  group('ConcurrentTasksQueue', () {
    test('runs tasks up to maxConcurrent', () async {
      final queue = ConcurrentTasksQueue(maxConcurrent: 2);
      final completers = [Completer<void>(), Completer<void>(), Completer<void>()];
      final results = <int>[];
      var running = 0;

      Future<void> task(int i) async {
        running++;
        await completers[i].future;
        results.add(i);
        running--;
      }

      final futures = [
        queue.add(() => task(0)),
        queue.add(() => task(1)),
        queue.add(() => task(2)),
      ];

      expect(running, 2);

      completers[0].complete();
      await Future<void>.delayed(Duration.zero);
      expect(running, 2);

      completers[1].complete();
      await Future<void>.delayed(Duration.zero);
      expect(running, 1);

      completers[2].complete();
      await Future.wait<dynamic>(futures);
      expect(results, containsAll([0, 1, 2]));
    });

    test('completes tasks in order', () async {
      final queue = ConcurrentTasksQueue(maxConcurrent: 1);
      final results = <int>[];
      Future<void> task(int i) async {
        await Future<void>.delayed(Duration(milliseconds: 10 * (3 - i)));
        results.add(i);
      }

      await queue.add(() => task(1));
      await queue.add(() => task(2));
      await queue.add(() => task(3));
      expect(results, [1, 2, 3]);
    });

    test('cancelAll cancels pending tasks', () async {
      final queue = ConcurrentTasksQueue(maxConcurrent: 1);
      final completer = Completer<void>();
      unawaited(queue.add(() async => completer.future));
      final f2 = queue.add(() async => 42);
      queue.cancelAll();
      completer.complete();
      await expectLater(f2, throwsA(isA<StateError>()));
    });

    test('propagates errors from tasks', () async {
      final queue = ConcurrentTasksQueue(maxConcurrent: 1);
      final f1 = queue.add(() async => throw Exception('fail'));
      await expectLater(f1, throwsA(isA<Exception>()));
    });
  });
}
