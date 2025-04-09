// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'money_message_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<FundsRequestEntity?> fundsRequestForMessage(
  Ref ref,
  String eventMessageId,
) async {
  final repository = ref.watch(requestAssetsRepositoryProvider);
  return repository.getRequestAssetById(eventMessageId);
}
