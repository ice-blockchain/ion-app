import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/templates/template.dart';


abstract class IcePage<Payload> extends HookConsumerWidget {
  const IcePage(IceRoutes route, Payload? payload) : _payload = payload, _route = route;

  final IceRoutes _route;

  final Payload? _payload;

  @override
  @nonVirtual
  Widget build(BuildContext context, WidgetRef ref) => buildPage(
        context,
        ref,
        page(ref, _route.name)?.controls,
        _payload,
      );

  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
    Map<String, TemplateConfigControl>? controlsConfig,
    Payload? payload,
  );
}

typedef IceSimplePage = IcePage<void>;

class AbsentPage extends IceSimplePage {
  const AbsentPage(super.route, super.payload);

  @override
  Widget buildPage(_, __, ___, ____) {
    throw UnsupportedError('AbsentPage is for declaration only, not for building.');
  }
}
