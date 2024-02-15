import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/templates/template.dart';

abstract class IceComponent extends HookConsumerWidget {
  const IceComponent({super.key});

  String get name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, TemplateConfigComponent>? componentsConfig =
        ComponentsConfigContext.of(context).componentsConfig;
    final TemplateConfigComponent? config = componentsConfig?[name];

    if (config?.hidden ?? false) {
      return const SizedBox.shrink();
    } else {
      return buildComponent(context, ref, config?.variant ?? 0);
    }
  }

  Widget buildComponent(BuildContext context, WidgetRef ref, int variant);
}
