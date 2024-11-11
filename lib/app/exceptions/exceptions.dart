// SPDX-License-Identifier: ice License 1.0

sealed class IONException implements Exception {
  const IONException(this.code, this.message);

  final int code;
  final String message;

  @override
  String toString() => 'IONException(code: $code, message: $message)';
}

class FollowListNotFoundException extends IONException {
  FollowListNotFoundException() : super(10001, 'Follow list is null');
}

class FollowListIsEmptyException extends IONException {
  FollowListIsEmptyException() : super(10002, 'Follow list is empty');
}

class KeystoreNotFoundException extends IONException {
  KeystoreNotFoundException() : super(10003, 'KeyStore is null');
}

class UserRelaysNotFoundException extends IONException {
  UserRelaysNotFoundException() : super(10004, 'User relays not found');
}

class UserIndexersNotFoundException extends IONException {
  UserIndexersNotFoundException() : super(10005, 'User indexers not found');
}

class IncorrectEventKindException extends IONException {
  IncorrectEventKindException({
    required int actual,
    required int expected,
  }) : super(10006, 'Incorrect event with kind $actual, expected $expected');
}

class IncorrectEventTagException extends IONException {
  IncorrectEventTagException({
    required String actual,
    required String expected,
  }) : super(10007, 'Incorrect event tag $actual, expected $expected');
}

class MainWalletNotFoundException extends IONException {
  MainWalletNotFoundException() : super(10008, 'Main wallet not found');
}

class UnauthenticatedException extends IONException {
  const UnauthenticatedException() : super(10009, 'Unauthenticated');
}

class CurrentUserNotFoundException extends IONException {
  const CurrentUserNotFoundException() : super(10010, 'Current user not found');
}

class GetFileStorageUrlException extends IONException {
  GetFileStorageUrlException(dynamic error)
      : super(10010, 'Failed to get file storage url: $error');
}
