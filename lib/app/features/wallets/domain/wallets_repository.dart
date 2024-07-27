import 'dart:async';

import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ice/app/services/storage/local_storage.dart';

class WalletsRepository {
  static const String _selectedWalletIdKey = 'UserPreferences:selectedWalletId';
  final LocalStorage localStorage;
  List<WalletData> _wallets;

  WalletsRepository(this.localStorage) : _wallets = List.from(mockedWalletDataArray);

  List<WalletData> get wallets => List.from(_wallets);

  String get currentWalletId => localStorage.getString(_selectedWalletIdKey) ?? _wallets.first.id;

  set currentWalletId(String id) => unawaited(localStorage.setString(_selectedWalletIdKey, id));

  void updateWallet(WalletData newWallet) {
    final index = _wallets.indexWhere((wallet) => wallet.id == newWallet.id);
    if (index != -1) {
      _wallets[index] = _wallets[index].copyWith(
        name: newWallet.name,
        icon: newWallet.icon,
        balance: newWallet.balance,
      );
    } else {
      _wallets.add(newWallet);
    }
  }

  void deleteWallet(String id) {
    _wallets.removeWhere((wallet) => wallet.id == id);
    if (_wallets.isEmpty) {
      _wallets = List.from(mockedWalletDataArray);
    }
  }

  void addWallet(WalletData newWallet) {
    if (!_wallets.any((wallet) => wallet.id == newWallet.id)) {
      _wallets.add(newWallet);
    }
  }
}
