// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/card/rounded_card.dart';
import 'package:ion/app/components/list_item/badges_user_list_item.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/features/wallets/model/transaction_type.dart';

class TransactionParticipant extends ConsumerWidget {
  const TransactionParticipant({
    required this.address,
    this.pubkey,
    this.transactionType = TransactionType.send,
    super.key,
  });

  final String? address;
  final String? pubkey;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final userMetadata =
        pubkey != null ? ref.watch(userMetadataProvider(pubkey!)).valueOrNull : null;

    if (userMetadata != null) {
      return RoundedCard.filled(
        child: Column(
          children: [
            BadgesUserListItem(
              title: Text(userMetadata.data.displayName),
              subtitle: Text(userMetadata.data.name),
              pubkey: userMetadata.masterPubkey,
            ),
            if (address != null) ...[
              SizedBox(height: 12.0.s),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  address!,
                  style: context.theme.appTextThemes.caption3,
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (address != null) {
      final title = switch (transactionType) {
        TransactionType.send => locale.wallet_sent_to,
        TransactionType.receive => locale.wallet_from,
      };
      return ListItem.textWithIcon(
        title: Text(title),
        secondary: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            address!,
            textAlign: TextAlign.end,
            style: context.theme.appTextThemes.caption3,
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
