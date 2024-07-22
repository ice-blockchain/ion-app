import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/components/auth_header/fade_on_scroll.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class AuthFadeInAppBar extends StatelessWidget {
  const AuthFadeInAppBar({
    super.key,
    this.showBackButton = true,
    required this.scrollController,
    required this.title,
  });

  final ScrollController scrollController;

  final String title;

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      flexibleSpace: NavigationAppBar.modal(
        showBackButton: showBackButton,
        title: FadeOnScroll(
          zeroOpacityOffset: 120.0.s,
          fullOpacityOffset: 140.0.s,
          scrollController: scrollController,
          child: Text(title),
        ),
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: NavigationAppBar.modalHeaderHeight,
      pinned: true,
    );
  }
}
