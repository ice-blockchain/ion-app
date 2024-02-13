import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';
import 'package:ice/app/templates/template.dart';

abstract class IceControl extends HookConsumerWidget {
  const IceControl({super.key});

  String get name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, TemplateConfigControl>? controlsConfig = ControlsConfigContext.of(context).controlsConfig;
    final TemplateConfigControl? config = controlsConfig?[name];

    if (config?.hidden ?? false) {
      return const SizedBox.shrink();
    } else {
      return buildControl(context, ref, config?.variant ?? 0);
    }
  }

  Widget buildControl(BuildContext context, WidgetRef ref, int variant);
}
