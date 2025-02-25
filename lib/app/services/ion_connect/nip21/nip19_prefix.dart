enum Nip19Prefix {
  nsec,
  npub,
  note,
  nprofile,
  nevent,
  naddr;

  static Nip19Prefix from(String name) => Nip19Prefix.values.byName(name.toLowerCase());
}

class Nip19PrefixValidator {
  static bool isProfileIdentifier(String? value) =>
      RegExp(r'^nostr:nprofile1[a-z0-9]+$').hasMatch(value ?? '');
  static bool isEventIdentifier(String? value) =>
      RegExp(r'^nostr:nevent1[a-z0-9]+$').hasMatch(value ?? '');
  static bool isAddressIdentifier(String? value) =>
      RegExp(r'^nostr:naddr1[a-z0-9]+$').hasMatch(value ?? '');
  static bool isPrivateKeyIdentifier(String? value) =>
      RegExp(r'^nostr:nsec1[a-z0-9]{58}$').hasMatch(value ?? '');
  static bool isPublicKeyIdentifier(String? value) =>
      RegExp(r'^nostr:npub1[a-z0-9]{58}$').hasMatch(value ?? '');
  static bool isNoteIdentifier(String? value) =>
      RegExp(r'^nostr:note1[a-z0-9]+$').hasMatch(value ?? '');
  static bool isEncryptedPrivateKeyIdentifier(String? value) =>
      RegExp(r'^nostr:ncryptsec1[a-z0-9]+$').hasMatch(value ?? '');
}
