import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/providers/unseen_transactions_count_provider.r.dart';

class UnseenTransactionsIndicator extends ConsumerWidget {
  const UnseenTransactionsIndicator({required this.coinIds, super.key});

  final List<String> coinIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnseenTransactionsAsync = ref.watch(hasUnseenTransactionsProvider(coinIds));

    return hasUnseenTransactionsAsync.when(
      data: (hasUnseen) {
        if (hasUnseen) {
          return Container(
            width: 6.0.s,
            height: 6.0.s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.appColors.primaryAccent,
            ),
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
