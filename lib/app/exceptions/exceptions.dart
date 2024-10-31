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

class IncorrectEventKindException extends IonException {
  IncorrectEventKindException({
    required int actual,
    required int excepted,
  }) : super(10005, 'Incorrect event with kind $actual, expected $excepted');
}

class IncorrectEventTagException extends IonException {
  IncorrectEventTagException({
    required String actual,
    required String excepted,
  }) : super(10006, 'Incorrect event tag $actual, expected $excepted');
}

class MainWalletNotFoundException extends IonException {
  MainWalletNotFoundException() : super(10007, 'Main wallet not found');
}
