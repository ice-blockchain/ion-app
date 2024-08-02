import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/contacts_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_provider.g.dart';

@riverpod
List<ContactData> contacts(ContactsRef ref) => mockedContactDataArray;

@riverpod
ContactData contactById(ContactByIdRef ref, {required String id}) {
  final contacts = ref.watch(contactsProvider);

  return contacts.firstWhere((element) => element.id == id);
}
