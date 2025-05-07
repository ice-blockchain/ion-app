// SPDX-License-Identifier: ice License 1.0

enum BalanceDisplayOrder {
  coinUsd,
  usdCoin;

  const BalanceDisplayOrder();

  BalanceDisplayOrder get toggled => switch (this) {
        BalanceDisplayOrder.coinUsd => BalanceDisplayOrder.usdCoin,
        BalanceDisplayOrder.usdCoin => BalanceDisplayOrder.coinUsd,
      };
}
