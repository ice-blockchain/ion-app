// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_back_button.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({required this.showBackButton, super.key});

  final bool showBackButton;

  Widget _skeletonBox({
    required double width,
    required double height,
    double borderRadius = 16.0,
  }) {
    return Skeleton(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return ScreenSideOffset.small(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton) NavigationBackButton(context.pop),
          _skeletonBox(
            width: 65.0.s,
            height: 65.0.s,
          ),
          _skeletonBox(
            width: 24.0.s,
            height: 24.0.s,
            borderRadius: 8.0.s,
          ),
        ],
      ),
    );
  }

  Widget _profileInfo() {
    return ScreenSideOffset.small(
      child: Column(
        children: [
          if (!showBackButton)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _skeletonBox(
                  width: 24.0.s,
                  height: 24.0.s,
                  borderRadius: 8.0.s,
                ),
                _skeletonBox(
                  width: 65.0.s,
                  height: 65.0.s,
                ),
                _skeletonBox(
                  width: 24.0.s,
                  height: 24.0.s,
                  borderRadius: 8.0.s,
                ),
              ],
            ),
          SizedBox(height: 16.0.s),
          _skeletonBox(
            width: 320.0.s,
            height: 20.0.s,
            borderRadius: 8.0.s,
          ),
          SizedBox(height: 6.0.s),
          _skeletonBox(
            width: 280.0.s,
            height: 16.0.s,
          ),
          SizedBox(height: 12.0.s),
          _skeletonBox(
            width: 120.0.s,
            height: 28.0.s,
          ),
          SizedBox(height: 12.0.s),
          _profileDetails(),
        ],
      ),
    );
  }

  Widget _profileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _skeletonBox(
          width: 343.0.s,
          height: 36.0.s,
        ),
        SizedBox(height: 12.0.s),
        _skeletonBox(
          width: 218.0.s,
          height: 16.0.s,
        ),
        SizedBox(height: 12.0.s),
        _skeletonBox(
          width: 343.0.s,
          height: 16.0.s,
        ),
        SizedBox(height: 5.0.s),
        _skeletonBox(
          width: 280.0.s,
          height: 16.0.s,
        ),
        SizedBox(height: 12.0.s),
        _skeletonBox(
          width: 343.0.s,
          height: 16.0.s,
        ),
        SizedBox(height: 12.0.s),
        _skeletonBox(
          width: 343.0.s,
          height: 16.0.s,
        ),
        SizedBox(height: 12.0.s),
        _skeletonBox(
          width: 343.0.s,
          height: 30.0.s,
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 4.0.s,
      color: Colors.white,
    );
  }

  Widget _additionalInfo() {
    return ScreenSideOffset.small(
      child: Column(
        children: [
          SizedBox(height: 12.0.s),
          _skeletonBox(
            width: double.infinity,
            height: 35.0.s,
          ),
          SizedBox(height: 12.0.s),
          _skeletonBox(
            width: double.infinity,
            height: 200.0.s,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (showBackButton) _header(context),
              Skeleton(
                child: Column(
                  children: [
                    _profileInfo(),
                    SizedBox(height: 12.0.s),
                    _divider(),
                    _additionalInfo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
