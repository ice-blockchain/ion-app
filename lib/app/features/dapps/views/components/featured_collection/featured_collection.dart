// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/providers/dapps_provider.dart';
import 'package:ice/app/features/dapps/views/components/featured_collection/shadow_text.dart';
import 'package:ice/app/router/app_routes.dart';

class FeaturedCollection extends ConsumerWidget {
  const FeaturedCollection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredApps = ref.watch(dappsFeaturedDataProvider).valueOrNull ?? [];
    return SizedBox(
      height: 160.0.s,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => SizedBox(width: 12.0.s),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        itemCount: featuredApps.length,
        itemBuilder: (BuildContext context, int index) {
          final item = featuredApps[index];
          final assetBg = item.backgroundImage ?? '';
          return GestureDetector(
            onTap: () => DAppDetailsRoute(dappId: item.identifier).push<void>(context),
            child: Container(
              width: 240.0.s,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0.s),
                image: DecorationImage(
                  image: AssetImage(
                    assetBg,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 12.0.s,
                    left: 12.0.s,
                    child: Row(
                      children: [
                        Image.asset(
                          featuredApps[index].iconImage,
                          width: 30.0.s,
                        ),
                        SizedBox(width: 8.0.s),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShadowText(
                              child: Text(
                                featuredApps[index].title,
                                style: context.theme.appTextThemes.body.copyWith(
                                  color: context.theme.appColors.secondaryBackground,
                                ),
                              ),
                            ),
                            ShadowText(
                              child: Text(
                                featuredApps[index].description ?? '',
                                style: context.theme.appTextThemes.caption3.copyWith(
                                  color: context.theme.appColors.secondaryBackground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
