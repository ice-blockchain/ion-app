// SPDX-License-Identifier: ice License 1.0

part of 'coin_networks_list_view.dart';

class _CoinNetworkItem extends ConsumerWidget {
  const _CoinNetworkItem({
    required this.coinAbbreviation,
    required this.network,
    required this.onTap,
  });

  final String coinAbbreviation;
  final NetworkData network;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinDataResult =
        ref.watch(coinInWalletByAbbreviationProvider(coinAbbreviation: coinAbbreviation));
    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);

    return coinDataResult.maybeWhen(
      data: (coinInWallet) {
        if (coinInWallet == null) {
          return ItemLoadingState(
            itemHeight: 60.0.s,
          );
        }
        final coinData = coinInWallet.coin;
        return ListItem(
          title: Row(
            children: [
              Text(coinData.name),
              SizedBox(
                width: 6.0.s,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 6.0.s,
                  right: 6.0.s,
                  bottom: 2.0.s,
                ),
                decoration: BoxDecoration(
                  color: context.theme.appColors.attentionBlock,
                  borderRadius: BorderRadius.circular(16.0.s),
                ),
                child: Text(
                  network.displayName,
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
              CoinIconWidget(
                imageUrl: coinData.iconUrl,
                size: 36.0.s,
              ),
              Positioned(
                bottom: -3.0.s,
                right: -3.0.s,
                child: NetworkIconWidget(
                  size: 16.0.s,
                  imageUrl: network.image,
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
      },
      orElse: () => ItemLoadingState(
        itemHeight: 60.0.s,
      ),
    );
  }
}
