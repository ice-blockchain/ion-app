// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: avoid_public_notifier_properties
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_id_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:mocktail/mocktail.dart';

class Listener<T> extends Mock {
  void call(T? previous, T value);
}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockSelectedWalletIdNotifier extends Notifier<String?>
    with Mock
    implements SelectedWalletIdNotifier {}

class MockWalletsDataNotifier extends AsyncNotifier<List<WalletData>>
    with Mock
    implements WalletsDataNotifier {
  MockWalletsDataNotifier(this.data);

  final List<WalletData> data;

  @override
  Future<List<WalletData>> build() async {
    return data;
  }
}
