import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/fade_on_scroll.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/position_controller.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class AuthScrollContainer extends HookWidget {
  const AuthScrollContainer({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.children = const [],
    this.showBackButton = true,
  });

  final List<Widget> children;

  final String? title;

  final String? description;

  final Widget? icon;

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final positionController = useMemoized(() => PositionController());
    return NotificationListener(
      onNotification: (notification) {
        // When the scroll is changed due to keyboard open / close
        if (notification is ScrollMetricsNotification) {
          positionController.setPosition(notification.metrics.pixels);
          return false;
        }
        // When scroll is changed by a user
        else if (notification is ScrollNotification) {
          positionController.setPosition(notification.metrics.pixels);
          return false;
        }
        return false;
      },
      child: SizedBox(
        height: double.infinity,
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
            SliverFillRemaining(
                hasScrollBody: false,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  AuthHeader(
                    title: title,
                    description: description,
                    icon: icon != null ? AuthHeaderIcon(icon: icon) : icon,
                  ),
                  ...children
                ]))
          ],
        ),
      ),
    );
  }
}
