// SPDX-License-Identifier: ice License 1.0

sealed class IonException implements Exception {
  IonException(this.code, this.message);

  final int code;
  final String message;

  @override
  String toString() => 'IonException(code: $code, message: $message)';
}

class FollowListNotFoundException extends IonException {
  FollowListNotFoundException() : super(10001, 'Follow list is null');
}

class FollowListIsEmptyException extends IonException {
  FollowListIsEmptyException() : super(10002, 'Follow list is empty');
}

class KeystoreNotFoundException extends IonException {
  KeystoreNotFoundException() : super(10003, 'KeyStore is null');
}

class UserRelaysNotFoundException extends IonException {
  UserRelaysNotFoundException() : super(10004, 'User relays not found');
}

class UserIndexersNotFoundException extends IonException {
  UserIndexersNotFoundException() : super(10005, 'User indexers not found');
}

class IncorrectEventKindException extends IonException {
  IncorrectEventKindException({
    required int actual,
    required int expected,
  }) : super(10006, 'Incorrect event with kind $actual, expected $expected');
}

class IncorrectEventTagException extends IonException {
  IncorrectEventTagException({
    required String actual,
    required String expected,
  }) : super(10007, 'Incorrect event tag $actual, expected $expected');
}

class MainWalletNotFoundException extends IonException {
  MainWalletNotFoundException() : super(10008, 'Main wallet not found');
}
