// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';

class CoinIconWithNetwork extends StatelessWidget {
  const CoinIconWithNetwork._({
    required this.iconUrl,
    required this.network,
    required this.coinSize,
    required this.networkSize,
    required this.containerSize,
  });

  factory CoinIconWithNetwork.small(
    String iconUrl, {
    required NetworkData network,
  }) =>
      CoinIconWithNetwork._(
        iconUrl: iconUrl,
        network: network,
        coinSize: 36.0.s,
        networkSize: 16.0.s,
        containerSize: 40.0.s,
      );

  factory CoinIconWithNetwork.medium(
    String iconUrl, {
    required NetworkData network,
  }) =>
      CoinIconWithNetwork._(
        iconUrl: iconUrl,
        network: network,
        coinSize: 46.0.s,
        networkSize: 21.0.s,
        containerSize: 51.0.s,
      );

  final String iconUrl;
  final NetworkData network;

  final double coinSize;
  final double networkSize;
  final double containerSize;

  @override
  Widget build(BuildContext context) {
    // Add 2 to handle the border
    final networkContainerSize = networkSize + 2.0.s;

    return SizedBox.square(
      dimension: containerSize,
      child: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            start: 0,
            child: CoinIconWidget(
              imageUrl: iconUrl,
              size: coinSize,
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: Container(
              height: networkContainerSize,
              width: networkContainerSize,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0.s,
                  color: context.theme.appColors.onPrimaryAccent,
                ),
                borderRadius: BorderRadius.circular(6.0.s),
              ),
              child: NetworkIconWidget(
                size: networkSize,
                imageUrl: network.image,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
