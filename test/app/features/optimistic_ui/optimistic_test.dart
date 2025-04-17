import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/optimistic_ui/operation_manager.dart';

// Sample model class for testing
class TestModel implements OptimisticModel {
  TestModel({required this.optimisticId, required this.value});
  @override
  final String optimisticId;
  final String value;

  @override
  String toString() => 'TestModel(id: $optimisticId, value: $value)';
}

void main() {
  group('OptimisticOperationManager Tests', () {
    late OptimisticOperationManager<TestModel> manager;
    late List<TestModel> syncedModels;
    late List<String> errorMessages;
    late StreamSubscription<List<TestModel>> subscription;
    late List<List<TestModel>> emittedStates;

    // Helper function to create a sync callback that simulates backend operations
    Future<void> mockSyncCallback(TestModel previous, TestModel next) async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      syncedModels.add(next);
    }

    // Helper function to create an error callback that tracks error messages
    Future<bool> mockErrorCallback(String message, dynamic error) async {
      errorMessages.add(message);
      return true; // Always retry by default
    }

    setUp(() {
      // Initialize fresh instances before each test
      syncedModels = [];
      errorMessages = [];
      emittedStates = [];
      manager = OptimisticOperationManager<TestModel>(
        syncCallback: mockSyncCallback,
        onError: mockErrorCallback,
      );

      // Set up stream subscription to capture all emitted states
      subscription = manager.stateStream.listen((state) {
        emittedStates.add(state);
      });
    });

    tearDown(() async {
      // Clean up after each test
      await subscription.cancel();
      manager.dispose();
    });

    test('initialize() should set the initial state correctly', () async {
      // Arrange
      final initialModels = [
        TestModel(optimisticId: '1', value: 'test1'),
        TestModel(optimisticId: '2', value: 'test2'),
      ];

      // Act
      manager.initialize(initialModels);

      // Wait for stream to emit
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(
        emittedStates.isNotEmpty,
        true,
        reason: 'Stream should have emitted at least one state',
      );
      expect(
        emittedStates.last,
        initialModels,
        reason: 'Last emitted state should match initial models',
      );
    });

    test('performOperation() should update local state immediately', () async {
      // Arrange
      final initialModel = TestModel(optimisticId: '1', value: 'initial');
      final updatedModel = TestModel(optimisticId: '1', value: 'updated');
      manager.initialize([initialModel]);

      // Clear previous emissions
      emittedStates.clear();

      // Act
      await manager.performOperation(
        previousState: initialModel,
        newState: updatedModel,
      );

      // Wait for stream to emit
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(
        emittedStates.isNotEmpty,
        true,
        reason: 'Stream should have emitted after operation',
      );
      expect(
        emittedStates.last.any((model) => model.optimisticId == '1' && model.value == 'updated'),
        true,
        reason: 'Local state should be updated immediately with new value',
      );
    });

    test('performOperation() should handle multiple sequential operations', () async {
      // Arrange
      final model1 = TestModel(optimisticId: '1', value: 'v1');
      final model2 = TestModel(optimisticId: '2', value: 'v2');
      manager.initialize([model1, model2]);

      // Clear previous emissions
      emittedStates.clear();

      // Act - Perform multiple operations in sequence
      await manager.performOperation(
        previousState: model1,
        newState: TestModel(optimisticId: '1', value: 'v1-updated'),
      );
      await manager.performOperation(
        previousState: model2,
        newState: TestModel(optimisticId: '2', value: 'v2-updated'),
      );

      // Wait for operations to complete
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      expect(
        emittedStates.isNotEmpty,
        true,
        reason: 'Stream should have emitted after operations',
      );
      expect(
        emittedStates.last.every(
          (model) =>
              (model.optimisticId == '1' && model.value == 'v1-updated') ||
              (model.optimisticId == '2' && model.value == 'v2-updated'),
        ),
        true,
        reason: 'Both operations should be reflected in the final state',
      );
    });

    test('should handle sync failures and retry logic', () async {
      // Arrange
      var retryCount = 0;
      manager = OptimisticOperationManager<TestModel>(
        syncCallback: (_, __) async {
          retryCount++;
          if (retryCount < 3) {
            throw Exception('Sync failed');
          }
        },
        onError: (message, _) async => true, // Always retry
      );

      // Set up new subscription for new manager
      await subscription.cancel();
      subscription = manager.stateStream.listen((state) {
        emittedStates.add(state);
      });

      final initialModel = TestModel(optimisticId: '1', value: 'initial');
      final updatedModel = TestModel(optimisticId: '1', value: 'updated');
      manager.initialize([initialModel]);
      emittedStates.clear();

      // Act
      await manager.performOperation(
        previousState: initialModel,
        newState: updatedModel,
      );

      // Wait for retries to complete
      await Future<void>.delayed(const Duration(seconds: 7));

      // Assert
      expect(
        retryCount,
        3,
        reason: 'Should retry the operation up to 3 times on failure',
      );
    });

    test('should revert state when operation ultimately fails', () async {
      // Arrange
      final initialModel = TestModel(optimisticId: '1', value: 'initial');
      manager = OptimisticOperationManager<TestModel>(
        syncCallback: (_, __) async => throw Exception('Permanent failure'),
        onError: (_, __) async => false, // Don't retry
      );

      // Set up new subscription for new manager
      await subscription.cancel();
      subscription = manager.stateStream.listen((state) {
        emittedStates.add(state);
      });

      manager.initialize([initialModel]);
      emittedStates.clear();

      // Act
      await manager.performOperation(
        previousState: initialModel,
        newState: TestModel(optimisticId: '1', value: 'updated'),
      );

      // Wait for operation to fail
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Assert
      expect(
        emittedStates.last.any((m) => m.optimisticId == '1' && m.value == 'initial'),
        true,
        reason: 'State should be reverted to initial value after permanent failure',
      );
    });

    test('should handle dependent operations correctly', () async {
      // Arrange
      final model1 = TestModel(optimisticId: '1', value: 'v1');
        final model2 = TestModel(optimisticId: '2', value: 'v2');

      manager = OptimisticOperationManager<TestModel>(
        syncCallback: (_, __) async {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          throw Exception('First sync fails');
        },
        onError: (_, err) async => false, // Don't retry
      );

      // Set up new subscription for new manager
      await subscription.cancel();

      subscription = manager.stateStream.listen((state) {
        emittedStates.add(state);
      });

      manager.initialize([model1, model2]);
      emittedStates.clear();

      await Future<void>.delayed(const Duration(milliseconds: 1000));

      // Act - Perform dependent operations
      await manager.performOperation(
        previousState: model1,
        newState: TestModel(optimisticId: '1', value: 'v1-updated'),
      );
      await manager.performOperation(
        previousState: model2,
        newState: TestModel(optimisticId: '2', value: 'v2-updated'),
      );

      // Wait for operations to process
      await Future<void>.delayed(const Duration(milliseconds: 2000));

      // Assert
      expect(
        emittedStates.last.every(
          (m) => (m.optimisticId == '1' && m.value == 'v1') || (m.optimisticId == '2' && m.value == 'v2'),
        ),
        true,
        reason: 'Both operations should be reverted when the first operation fails',
      );
    });
  });
}
