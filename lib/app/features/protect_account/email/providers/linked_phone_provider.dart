// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/user_details_provider.dart';
import 'package:ion/app/utils/predicates.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'linked_phone_provider.g.dart';

@riverpod
Future<String> linkedPhone(Ref ref) async {
  final userDetails = await ref.watch(userDetailsProvider.future);

  final phones = userDetails.phoneNumber ?? [];
  if (phones.isEmpty) {
    throw StateError('No phone linked');
  }

  final phoneIndex = int.tryParse(
        userDetails.twoFaOptions
                ?.firstWhereOrNull(startsWith(const TwoFAType.sms().option))
                ?.split(':')
                .firstOrNull ??
            '0',
      ) ??
      0;

  final phone = phones[phoneIndex];
  if (phone.length <= 6) {
    return phone;
  }
  final start = phone.substring(0, 5);
  final end = phone.substring(phone.length - 2);
  return '$start***$end';
}
