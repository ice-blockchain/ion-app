import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';

class NetworkItem extends StatelessWidget {
  const NetworkItem({
    super.key,
    required this.networkType,
    required this.onTap,
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
