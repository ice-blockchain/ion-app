// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/wallets/providers/repository/nfts_repository.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfts_repository_provider.c.g.dart';

@riverpod
NftsRepository nftsRepository(Ref ref) => NftsRepository(ref.watch(dioProvider));
