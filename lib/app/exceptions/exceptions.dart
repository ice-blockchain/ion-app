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
    required String eventId,
    required int kind,
  }) : super(10006, 'Incorrect event $eventId, expected kind $kind');
}

class IncorrectEventTagNameException extends IONException {
  IncorrectEventTagNameException({
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

class IncorrectEventTagsException extends IONException {
  IncorrectEventTagsException({required String eventId})
      : super(10011, 'Incorrect event $eventId tags');
}

class UnknownEventException extends IONException {
  UnknownEventException({required String eventId, required int kind})
      : super(10012, 'Unknown event $eventId with kind $kind');
}

class IncorrectEventTagException extends IONException {
  IncorrectEventTagException({required String tag}) : super(10013, 'Incorrect event tag $tag');
}

class QuillParseException extends IONException {
  const QuillParseException(dynamic error)
      : super(10014, 'Invalid content format for Quill Delta: $error');
}

class UnsupportedRepostException extends IONException {
  UnsupportedRepostException({required String eventId})
      : super(10015, 'Reposting events with $eventId is not supported');
}

class EventNotFoundException extends IONException {
  EventNotFoundException({required String eventId, required String pubkey})
      : super(10016, 'Event with id $eventId not found for pubkey $pubkey');
}

class AssetEntityFileNotFoundException extends IONException {
  AssetEntityFileNotFoundException() : super(10018, 'Asset entity file not found');
}

class UnknownEventCountResultType extends IONException {
  UnknownEventCountResultType({required String eventId})
      : super(10019, 'Unknown EventCount result type $eventId');
}

class UnknownEventCountResultKey extends IONException {
  UnknownEventCountResultKey({required String eventId})
      : super(10020, 'Unknown EventCount result key $eventId');
}

class UnsupportedSignatureAlgorithmException extends IONException {
  UnsupportedSignatureAlgorithmException(String algorithm)
      : super(10021, 'Unsupported signature algorithm - $algorithm');
}

class EventMasterPubkeyNotFoundException extends IONException {
  EventMasterPubkeyNotFoundException({required String eventId})
      : super(10022, 'Master pubkey is not found in event $eventId');
}

class UserMasterPubkeyNotFoundException extends IONException {
  UserMasterPubkeyNotFoundException({String? pubkey})
      : super(
          10023,
          'Master pubkey is not found for ${pubkey == null ? "current user" : 'user $pubkey'}',
        );
}

class RequiredFieldIsEmptyException extends IONException {
  RequiredFieldIsEmptyException({required String field})
      : super(10024, 'Required field is empty $field');
}

class FileUploadException extends IONException {
  FileUploadException(dynamic error, {required String url})
      : super(10025, 'Failed to upload file to $url: $error');
}

class UnknownUploadFileResolutionException extends IONException {
  UnknownUploadFileResolutionException() : super(10026, 'Unknown upload file resolution');
}

class CompressImageException extends IONException {
  CompressImageException(dynamic error) : super(10027, 'Compress image exception: $error');
}
