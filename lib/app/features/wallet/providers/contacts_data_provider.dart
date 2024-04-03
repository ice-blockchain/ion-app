import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/contacts_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_data_provider.g.dart';

@Riverpod(keepAlive: true)
class ContactsDataNotifier extends _$ContactsDataNotifier {
  @override
  Map<String, ContactData> build() {
    final Map<String, ContactData> contacts = <String, ContactData>{};
    return Map<String, ContactData>.unmodifiable(contacts);
  }

  void fetchContacts() {
    final Map<String, ContactData> contacts = <String, ContactData>{};
    for (final ContactData contactData in mockedContactDataArray) {
      contacts.putIfAbsent(contactData.id, () => contactData);
    }
    state = Map<String, ContactData>.unmodifiable(contacts);
  }
}
