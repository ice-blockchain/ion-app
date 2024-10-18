// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';

class NetworkItem extends StatelessWidget {
  const NetworkItem({
    required this.networkType,
    required this.onTap,
    super.key,
  });

  final NetworkType networkType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Text(networkType.getDisplayName(context)),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: networkType.iconAsset.icon(size: 16.0.s),
      onTap: onTap,
    );
  }
}
