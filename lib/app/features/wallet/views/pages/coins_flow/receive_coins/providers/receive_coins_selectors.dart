import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.dart';

CoinData receiveCoinSelector(WidgetRef ref) => ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.selectedCoin),
    );

String receiveAddressSelector(WidgetRef ref) => ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.address),
    );

NetworkType receiveNetworkSelector(WidgetRef ref) => ref.watch(
      receiveCoinsFormControllerProvider
          .select((state) => state.selectedNetwork),
    );
