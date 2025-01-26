import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<Wallet>> wallets(Ref ref) async {
  final ionIdentity = await ref.watch(ionIdentityClientProvider.future);
  return ionIdentity.wallets.getWallets();
}
