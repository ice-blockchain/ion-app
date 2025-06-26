// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/user_details_provider.r.dart';
import 'package:ion/app/utils/predicates.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'linked_email_provider.r.g.dart';

@riverpod
Future<String> linkedEmail(Ref ref) async {
  final userDetails = await ref.watch(userDetailsProvider.future);

  final emails = userDetails.email ?? [];
  if (emails.isEmpty) {
    throw StateError('No email linked');
  }

  final emailIndex = int.tryParse(
        userDetails.twoFaOptions
                ?.firstWhereOrNull(startsWith(const TwoFAType.email().option))
                ?.split(':')
                .firstOrNull ??
            '0',
      ) ??
      0;

  final email = emails[emailIndex];
  return email;
}
