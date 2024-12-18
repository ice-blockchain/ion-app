import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ListItemNetworkFee extends StatelessWidget {
  const ListItemNetworkFee({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return ListItem.textWithIcon(
      title: Row(
        children: [
          Text(context.i18n.wallet_network_fee),
          SizedBox(width: 6.0.s),
          IconTheme(
            data: IconThemeData(
              size: 14.0.s,
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                context.theme.appColors.secondaryText,
                BlendMode.srcIn,
              ),
              child: Assets.svg.iconBlockInformation.icon(size: 14.0.s),
            ),
          ),
        ],
      ),
      value: value,
      icon: Assets.svg.iconBlockCoins.icon(size: 16.0.s),
    );
  }
}
