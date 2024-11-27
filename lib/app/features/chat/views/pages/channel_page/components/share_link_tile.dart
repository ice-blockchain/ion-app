// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/channels_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareLinkTile extends ConsumerWidget {
  const ShareLinkTile({
    required this.pubkey,
    super.key,
  });

  static double get height => 58.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelData = ref.watch(channelsProvider.select((channelMap) => channelMap[pubkey]));

    if (channelData == null) {
      return const SizedBox.shrink();
    }

    return ListItem(
      onTap: () => Clipboard.setData(ClipboardData(text: channelData.link)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 12.0.s),
      backgroundColor: context.theme.appColors.secondaryBackground,
      border: Border.all(
        color: context.theme.appColors.strokeElements,
      ),
      title: Text(
        context.i18n.common_share_link,
        style: context.theme.appTextThemes.caption2.copyWith(
          color: context.theme.appColors.tertararyText,
        ),
      ),
      subtitle: Text(
        channelData.link,
        style: context.theme.appTextThemes.body,
      ),
      trailing: Assets.svg.iconBlockCopyBlue.icon(
        size: 20.0.s,
        color: context.theme.appColors.primaryAccent,
      ),
    );
  }
}
