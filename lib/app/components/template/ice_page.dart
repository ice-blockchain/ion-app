import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/templates/template.dart';

abstract class IcePage<Payload> extends HookConsumerWidget {
  const IcePage(IceRoutes route, Payload? payload)
      : _payload = payload,
        _route = route;

  final IceRoutes _route;

  final Payload? _payload;

  @override
  @nonVirtual
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget pageWidget = buildPage(
      context,
      ref,
      _payload,
    );

    return ControlsConfigContext(
      controlsConfig: page(ref, _route.name)?.controls,
      child: pageWidget,
    );
  }

  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
    Payload? payload,
  );
}

//TODO::rewrite with ProviderScope
class ControlsConfigContext extends InheritedWidget {
  const ControlsConfigContext({
    required this.controlsConfig,
    required super.child,
  });

  final Map<String, TemplateConfigControl>? controlsConfig;

  static ControlsConfigContext of(BuildContext context) {
    final ControlsConfigContext? result =
        context.dependOnInheritedWidgetOfExactType<ControlsConfigContext>();
    assert(result != null, 'No ControlsConfigContext found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ControlsConfigContext oldWidget) =>
      controlsConfig != oldWidget.controlsConfig;
}

typedef IceSimplePage = IcePage<void>;

class AbsentPage extends IceSimplePage {
  const AbsentPage(super.route, super.payload);

  @override
  Widget buildPage(_, __, ____) {
    throw UnsupportedError(
      'AbsentPage is for declaration only, not for building.',
    );
  }
}
