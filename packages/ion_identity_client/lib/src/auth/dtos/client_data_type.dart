// SPDX-License-Identifier: ice License 1.0

enum ClientDataType {
  createKey,
  getKey,
}

extension ClientDataTypeExtension on ClientDataType {
  String get value {
    switch (this) {
      case ClientDataType.createKey:
        return 'key.create';
      case ClientDataType.getKey:
        return 'key.get';
    }
  }
}
