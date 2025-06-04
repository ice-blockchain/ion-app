// SPDX-License-Identifier: ice License 1.0

part of 'coin_networks_list_view.dart';

class _CoinNetworkItem extends ConsumerWidget {
  const _CoinNetworkItem({
    required this.coinInWallet,
    required this.onTap,
  });

  final CoinInWalletData coinInWallet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);
    final coinData = coinInWallet.coin;

    return ListItem(
      title: Row(
        children: [
          Text(coinData.name),
          SizedBox(
            width: 6.0.s,
          ),
          Container(
            padding: EdgeInsetsDirectional.only(
              start: 6.0.s,
              end: 6.0.s,
              bottom: 2.0.s,
            ),
            decoration: BoxDecoration(
              color: context.theme.appColors.attentionBlock,
              borderRadius: BorderRadius.circular(16.0.s),
            ),
            child: Text(
              coinData.network.displayName,
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.quaternaryText,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(coinData.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CoinIconWidget.big(coinData.iconUrl),
          PositionedDirectional(
            bottom: -3.0.s,
            end: -3.0.s,
            child: NetworkIconWidget(
              size: 16.0.s,
              imageUrl: coinData.network.image,
            ),
          ),
        ],
      ),
      onTap: onTap,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            isBalanceVisible ? formatDouble(coinInWallet.amount) : '****',
            style: context.theme.appTextThemes.body
                .copyWith(color: context.theme.appColors.primaryText),
          ),
          Text(
            isBalanceVisible ? formatToCurrency(coinInWallet.balanceUSD) : '******',
            style: context.theme.appTextThemes.caption3
                .copyWith(color: context.theme.appColors.secondaryText),
          ),
        ],
      ),
    );
  }
}
