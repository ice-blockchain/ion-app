// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ProfileBlock extends ConsumerWidget {
  const ProfileBlock({
    required this.reference,
    required this.profileNavigationEnabled,
    super.key,
  });

  final EventReference reference;
  final bool profileNavigationEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadata = ref
        .watch(
          ionConnectEntityProvider(
            eventReference: reference,
          ),
        )
        .valueOrNull as UserMetadataEntity?;

    if (metadata == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: profileNavigationEnabled
          ? () {
              ProfileRoute(pubkey: metadata.masterPubkey).push<void>(context);
            }
          : null,
      child: Text(
        '@${metadata.data.name}',
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.primaryAccent,
          height: 1.2,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
