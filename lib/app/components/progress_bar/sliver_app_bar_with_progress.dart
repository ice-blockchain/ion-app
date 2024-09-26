import 'package:flutter/material.dart';
import 'package:ice/app/components/progress_bar/app_progress_bar.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class SliverAppBarWithProgress extends StatelessWidget {
  const SliverAppBarWithProgress({
    required this.title, required this.onClose, super.key,
    this.progressValue,
    this.showBackButton = true,
    this.showProgress = true,
  });

  final double? progressValue;
  final String? title;
  final VoidCallback onClose;
  final bool showBackButton;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final showProgressIndicator = showProgress && progressValue != null;

    return SliverAppBar(
      primary: false,
      flexibleSpace: Column(
        children: [
          NavigationAppBar.modal(
            title: title != null ? Text(title!) : null,
            showBackButton: showBackButton,
            actions: [
              NavigationCloseButton(onPressed: onClose),
            ],
          ),
          if (showProgressIndicator) AppProgressIndicator(progressValue: progressValue!),
        ],
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: NavigationAppBar.modalHeaderHeight + (showProgressIndicator ? 3.0.s : 0),
      pinned: true,
    );
  }
}
