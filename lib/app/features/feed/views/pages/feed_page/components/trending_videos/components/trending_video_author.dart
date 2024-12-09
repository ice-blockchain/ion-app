// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

class TrendingVideoAuthor extends ConsumerWidget {
  const TrendingVideoAuthor({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey));

    return userMetadata.maybeWhen(
      data: (author) {
        if (author == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.all(8.0.s),
          child: TextButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.all(4.0.s),
              child: Row(
                children: [
                  Avatar(
                    size: 20.0.s,
                    imageUrl: author.data.picture,
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0.s),
                      child: Text(
                        author.data.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.appTextThemes.caption3.copyWith(
                          color: context.theme.appColors.secondaryBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      orElse: () => const Skeleton(child: _TrendingVideoAuthorShape()),
    );
  }
}

class _TrendingVideoAuthorShape extends StatelessWidget {
  const _TrendingVideoAuthorShape();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0.s).copyWith(right: 36.0.s),
      height: 20.0.s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.s),
        color: Colors.white,
      ),
    );
  }
}
