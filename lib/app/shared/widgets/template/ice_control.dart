import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/templates/template.dart';

abstract class IceControl extends HookConsumerWidget {
  IceControl(Map<String, TemplateConfigControl>? controlsConfig) : _controlsConfig = controlsConfig;

  String get name => runtimeType.toString();

  final Map<String, TemplateConfigControl>? _controlsConfig;

  late final TemplateConfigControl? _config = _controlsConfig?[name];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_config?.hidden ?? false) {
      return const SizedBox.shrink();
    } else {
      return buildControl(context, ref, _config);
    }
  }

  Widget buildControl(BuildContext context, WidgetRef ref, TemplateConfigControl? config);
}
