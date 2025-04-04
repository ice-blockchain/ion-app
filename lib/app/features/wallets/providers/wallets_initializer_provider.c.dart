import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coin_initializer.c.dart';
import 'package:ion/app/features/wallets/domain/networks/networks_initializer.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_initializer_provider.c.g.dart';

/// Returns true, if wallets db and all related services are ready to use.
@Riverpod(keepAlive: true)
Future<void> walletsInitializer(Ref ref) async {
  final authState = await ref.watch(authProvider.future);

  if (!authState.isAuthenticated) {
    throw const UnauthenticatedException();
  }

  await Future.wait([
    ref.watch(coinInitializerProvider).initialize(),
    ref.watch(networksInitializerProvider).initialize(),
    ref.watch(syncTransactionsServiceProvider.future).then((service) => service.sync()),
  ]);
}
