// SPDX-License-Identifier: ice License 1.0

class PasswordProtectedCredential {
  PasswordProtectedCredential({
    required this.encryptedPrivateKey,
    required this.password,
  });

  final String encryptedPrivateKey;
  final String password;

  Map<String, dynamic> toJson() => {
        'encryptedPrivateKey': encryptedPrivateKey,
        'password': password,
      };
}
