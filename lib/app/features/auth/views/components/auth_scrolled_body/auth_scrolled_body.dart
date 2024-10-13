// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/fade_on_scroll.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class AuthScrollContainer extends HookWidget {
  const AuthScrollContainer({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.children = const [],
    this.slivers = const [],
    this.showBackButton = true,
    this.actions,
    this.titleStyle,
    this.descriptionStyle,
    this.mainAxisAlignment,
  });

  final List<Widget> children;

  final List<Widget> slivers;

  final String? title;

  final String? description;

  final Widget? icon;

  final bool showBackButton;

  final List<Widget>? actions;

  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final positionNotifier = useMemoized(() => ValueNotifier<double>(0));
    return NotificationListener(
      onNotification: (notification) {
        // When the scroll is changed due to keyboard open / close
        if (notification is ScrollMetricsNotification) {
          positionNotifier.value = notification.metrics.pixels;
          return false;
        }
        // When the scroll is changed by a user
        else if (notification is ScrollNotification) {
          positionNotifier.value = notification.metrics.pixels;
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
                actions: actions,
                title: title != null
                    ? FadeOnScroll(
                        zeroOpacityOffset: 120.0.s,
                        fullOpacityOffset: 140.0.s,
                        positionNotifier: positionNotifier,
                        child: Text(title!),
                      )
                    : null,
              ),
              automaticallyImplyLeading: false,
              toolbarHeight: NavigationAppBar.modalHeaderHeight,
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: AuthHeader(
                title: title,
                description: description,
                titleStyle: titleStyle,
                descriptionStyle: descriptionStyle,
                icon: icon != null ? AuthHeaderIcon(icon: icon) : icon,
              ),
            ),
            if (children.isNotEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
                  children: children,
                ),
              ),
            ...slivers,
          ],
        ),
      ),
    );
  }
}
