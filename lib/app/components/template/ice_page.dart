// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:ice/app/router/app_routes.dart';
// import 'package:ice/app/templates/template.dart';

// abstract class IcePage<Payload> extends HookConsumerWidget {
//   const IcePage(IceRoutes<dynamic> route, dynamic payload, {super.key})
//       : _payload = payload as Payload?,
//         _route = route as IceRoutes<Payload>;

//   final IceRoutes<Payload> _route;

//   final Payload? _payload;

//   @override
//   @nonVirtual
//   Widget build(BuildContext context, WidgetRef ref) {
//     final pageWidget = buildPage(
//       context,
//       ref,
//       _payload,
//     );

//     return const SizedBox.shrink();

//     // return ComponentsConfigContext(
//     //   componentsConfig: page(ref, _route.name)?.components,
//     //   child: pageWidget,
//     // );
//   }

//   Widget buildPage(
//     BuildContext context,
//     WidgetRef ref,
//     Payload? payload,
//   );
// }

// //TODO::rewrite with ProviderScope
// class ComponentsConfigContext extends InheritedWidget {
//   const ComponentsConfigContext({
//     required this.componentsConfig,
//     required super.child,
//     super.key,
//   });

//   final Map<String, TemplateConfigComponent>? componentsConfig;

//   static ComponentsConfigContext of(BuildContext context) {
//     final result =
//         context.
// dependOnInheritedWidgetOfExactType<ComponentsConfigContext>();
//     assert(result != null, 'No ControlsConfigContext found in context');
//     return result!;
//   }

//   @override
//   bool updateShouldNotify(ComponentsConfigContext oldWidget) =>
//       componentsConfig != oldWidget.componentsConfig;
// }

// // typedef IceSimplePage = IcePage<void>;
