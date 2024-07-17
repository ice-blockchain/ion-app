import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_type.dart';
import 'package:ice/app/utils/num.dart';

class SendFundsSummary extends StatelessWidget {
  const SendFundsSummary({
    required this.type,
    required this.coin,
    super.key,
  });

  final TransactionType type;
  final CoinData coin;

  @override
  Widget build(BuildContext context) {
    final text = '${formatToCurrency(coin.amount, '')} ${coin.abbreviation}';
    if (type == TransactionType.coinTransaction) {
      return Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              coin.iconUrl.icon(size: 24.0.s),
              SizedBox(width: 12.0.s),
              Text(
                text,
                style: context.theme.appTextThemes.headline2,
              ),
            ],
          ),
          SizedBox(height: 4.0.s),
          Text(
            '~ ${formatToCurrency(coin.balance)}',
            style: context.theme.appTextThemes.subtitle2.copyWith(
              color: context.theme.appColors.onTertararyBackground,
            ),
          ),
        ],
      );
    } else if (type == TransactionType.nftTransaction) {
      return const SizedBox.shrink(); //TODO: Implement nft UI
    } else {
      return const SizedBox.shrink();
    }
  }
}
