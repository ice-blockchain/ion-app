import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/optimistic-update/model/optimistic_model.dart';
import 'package:ion/app/features/optimistic-update/provider/optimistic_example_update_provider.c.dart';

/// Example entity implementing OptimisticModel for demonstration.
class ExampleEntity implements OptimisticModel {
  const ExampleEntity({required this.id, required this.value});
  @override
  final String id;
  final String value;
}

/// Example view demonstrating optimistic update usage.
class OptimisticUpdateExampleView extends HookConsumerWidget {
  const OptimisticUpdateExampleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      optimisticExampleUpdateControllerProvider(
        syncCallback: (prev, next) async {
          await Future<void>.delayed(const Duration(milliseconds: 500));
        },
        onError: (msg, err) async => false,
      ),
    );
    final textController = useTextEditingController();
    final items = useState<List<ExampleEntity>>([]);

    useEffect(
      () {
        controller.initialize([]);
        final sub = controller.stateStream.listen((state) => items.value = state);
        return sub.cancel;
      },
      [controller],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Optimistic Update Example')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(labelText: 'Value'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final value = textController.text.trim();
                    if (value.isEmpty) return;
                    final entity =
                        ExampleEntity(id: DateTime.now().toIso8601String(), value: value);
                    controller.performOperation(
                      previousState: entity,
                      newState: entity,
                    );
                    textController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.value.length,
              itemBuilder: (context, index) {
                final item = items.value[index];
                return ListTile(
                  title: Text(item.value),
                  subtitle: Text(item.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
