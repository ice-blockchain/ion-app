import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_header/fade_on_scroll.dart';
import 'package:ice/app/features/auth/views/components/auth_header/position_controller.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class AuthScrollContainer extends HookWidget {
  const AuthScrollContainer({
    super.key,
    this.title,
    this.slivers = const [],
    this.showBackButton = true,
  });

  final List<Widget> slivers;

  final String? title;

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final positionController = useMemoized(() => PositionController());
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollMetricsNotification) {
          positionController.setPosition(notification.metrics.pixels);
          return false;
        } else if (notification is ScrollNotification) {
          positionController.setPosition(notification.metrics.pixels);
          return false;
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              showBackButton: showBackButton,
              title: title != null
                  ? FadeOnScroll(
                      zeroOpacityOffset: 120.0.s,
                      fullOpacityOffset: 140.0.s,
                      positionController: positionController,
                      child: Text(title!),
                    )
                  : null,
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: NavigationAppBar.modalHeaderHeight,
            pinned: true,
          ),
          ...slivers
        ],
      ),
    );
  }
}
