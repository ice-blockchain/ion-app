// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_social_profile_provider.c.g.dart';

@riverpod
Future<List<Map<String, dynamic>>> updateUserSocialProfile(
  Ref ref, {
  required UserSocialProfileData data,
}) async {
  final ionIdentityClient = await ref.watch(ionIdentityClientProvider.future);
  return ionIdentityClient.users.updateUserSocialProfile(data: data);
}
