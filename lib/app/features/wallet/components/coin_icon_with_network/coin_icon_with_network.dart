// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';

class CoinIconWithNetwork extends StatelessWidget {
  const CoinIconWithNetwork._({
    required this.coin,
    required this.network,
    required this.coinSize,
    required this.networkSize,
    required this.containerSize,
  });

  factory CoinIconWithNetwork.small(
    CoinData coin, {
    required NetworkType network,
  }) =>
      CoinIconWithNetwork._(
        coin: coin,
        network: network,
        coinSize: 36.0.s,
        networkSize: 16.0.s,
        containerSize: 39.0.s,
      );

  factory CoinIconWithNetwork.medium(
    CoinData coin, {
    required NetworkType network,
  }) =>
      CoinIconWithNetwork._(
        coin: coin,
        network: network,
        coinSize: 46.0.s,
        networkSize: 21.0.s,
        containerSize: 50.0.s,
      );

  final CoinData coin;
  final NetworkType network;

  final double coinSize;
  final double networkSize;
  final double containerSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: containerSize,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: CoinIconWidget(
              imageUrl: coin.iconUrl,
              size: coinSize,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: network.iconAsset.icon(size: networkSize),
          ),
        ],
      ),
    );
  }
}
