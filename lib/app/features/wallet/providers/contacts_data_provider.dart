// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/model/contact_data.dart';
import 'package:ion/app/features/wallet/providers/mock_data/contacts_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_data_provider.g.dart';

@Riverpod(keepAlive: true)
class ContactsDataNotifier extends _$ContactsDataNotifier {
  @override
  Future<Map<String, ContactData>> build() async {
    // Simulate a network delay
    await Future<void>.delayed(const Duration(seconds: 2));

    final contacts = <String, ContactData>{};
    for (final contactData in mockedContactDataArray) {
      contacts[contactData.id] = contactData;
    }
    return Map<String, ContactData>.unmodifiable(contacts);
  }
}
