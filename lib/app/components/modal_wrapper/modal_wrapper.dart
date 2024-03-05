import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/keyboard_hider/keyboard_hider.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/app_routes.dart';

class ModalWrapper extends HookConsumerWidget {
  const ModalWrapper({super.key, required this.payload});

  final dynamic payload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IceRoutes<dynamic> route = ref.watch(routeProvider);

    return Align(
      alignment: Alignment.bottomCenter,
      child: KeyboardHider(
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0.s)),
          child: route.builder(route, payload),
        ),
      ),
    );
  }
}
