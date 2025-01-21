// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/contact_data.c.dart';
import 'package:ion/app/features/wallets/providers/mock_data/contacts_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_provider.c.g.dart';

@riverpod
List<ContactData> contacts(Ref ref) => mockedContactDataArray;

@riverpod
ContactData contactById(Ref ref, {required String id}) {
  final contacts = ref.watch(contactsProvider);

  return contacts.firstWhere((element) => element.id == id);
}
