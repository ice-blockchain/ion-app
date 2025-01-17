// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: avoid_public_notifier_properties
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_view_id_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:mocktail/mocktail.dart';

class Listener<T> extends Mock {
  void call(T? previous, T value);
}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockSelectedWalletIdNotifier extends Notifier<String?>
    with Mock
    implements SelectedWalletViewIdNotifier {}

class MockWalletsDataNotifier extends AsyncNotifier<List<WalletViewData>>
    with Mock
    implements WalletViewsDataNotifier {
  MockWalletsDataNotifier(this.data);

  final List<WalletViewData> data;

  @override
  Future<List<WalletViewData>> build() async {
    return data;
  }
}
