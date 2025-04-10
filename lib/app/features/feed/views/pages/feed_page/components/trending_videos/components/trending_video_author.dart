// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class TrendingVideoAuthor extends ConsumerWidget {
  const TrendingVideoAuthor({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(cachedUserMetadataProvider(pubkey));

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    final boxShadow = [
      BoxShadow(
        offset: const Offset(0, 1),
        blurRadius: 1,
        color: Colors.black.withValues(alpha: 0.40),
      ),
    ];

    return Padding(
      padding: EdgeInsets.all(8.0.s),
      child: TextButton(
        onPressed: () {
          ProfileRoute(pubkey: pubkey).push<void>(context);
        },
        child: Padding(
          padding: EdgeInsets.all(4.0.s),
          child: Row(
            children: [
              Avatar(
                size: 20.0.s,
                imageUrl: userMetadata.data.picture,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 4.0.s),
                  child: Text(
                    userMetadata.data.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.appTextThemes.caption3.copyWith(
                      color: context.theme.appColors.secondaryBackground,
                      shadows: boxShadow,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
