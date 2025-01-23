// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/ion_connect.dart';

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

class EventSignerNotFoundException extends IONException {
  EventSignerNotFoundException() : super(10003, 'Event signer is null');
}

class UserRelaysNotFoundException extends IONException {
  UserRelaysNotFoundException() : super(10004, 'User relays not found');
}

class UserIndexersNotFoundException extends IONException {
  UserIndexersNotFoundException() : super(10005, 'User indexers not found');
}

class IncorrectEventKindException extends IONException {
  IncorrectEventKindException(
    dynamic eventInfo, {
    required int kind,
  }) : super(10006, 'Incorrect event $eventInfo, expected kind $kind');
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
  UnsupportedRepostException(dynamic eventInfo)
      : super(10015, 'Reposting event $eventInfo is not supported');
}

class AssetEntityFileNotFoundException extends IONException {
  AssetEntityFileNotFoundException() : super(10018, 'Asset entity file not found');
}

class UnknownEventCountResultType extends IONException {
  UnknownEventCountResultType(dynamic eventInfo)
      : super(10019, 'Unknown EventCount result type $eventInfo');
}

class UnknownEventCountResultKey extends IONException {
  UnknownEventCountResultKey(dynamic eventInfo)
      : super(10020, 'Unknown EventCount result key $eventInfo');
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

class UnknownFileResolutionException extends IONException {
  UnknownFileResolutionException() : super(10026, 'Unknown upload file resolution');
}

class CompressImageException extends IONException {
  CompressImageException(dynamic error) : super(10027, 'Compress image exception: $error');
}

class EntityNotFoundException extends IONException {
  EntityNotFoundException(dynamic entityInfo) : super(10028, 'Entity not found $entityInfo');
}

class CompressVideoException extends IONException {
  CompressVideoException(dynamic error) : super(10029, 'Failed to compress video: $error');
}

class CompressAudioException extends IONException {
  CompressAudioException() : super(10030, 'Failed to convert audio to opus.');
}

class CompressAudioToWavException extends IONException {
  CompressAudioToWavException() : super(10031, 'Failed to convert audio to wav.');
}

class ExtractThumbnailException extends IONException {
  ExtractThumbnailException(dynamic error) : super(10032, 'Failed to extract thumbnail: $error');
}

class CompressWithBrotliException extends IONException {
  CompressWithBrotliException() : super(10033, 'Failed to compress file with Brotli.');
}

class DecompressBrotliException extends IONException {
  DecompressBrotliException() : super(10034, 'Failed to decompress Brotli file.');
}

class ConversationIsNotFoundException extends IONException {
  ConversationIsNotFoundException() : super(10035, 'Failed to find conversation');
}

class VerifyIdentityException extends IONException {
  VerifyIdentityException() : super(10036, 'Verify identity exception.');
}

class UnknownMediaTypeException extends IONException {
  UnknownMediaTypeException() : super(10037, 'Unknown media type');
}

class UnsupportedParentEntity extends IONException {
  UnsupportedParentEntity(dynamic eventInfo)
      : super(10038, 'Unsupported parent entity: $eventInfo');
}

class RelayRequestFailedException extends IONException {
  RelayRequestFailedException({
    required String relayUrl,
    required this.event,
  }) : super(
          10039,
          'Relay request failed: $relayUrl, event $event',
        );

  RelayMessage event;
}

class UserChatRelaysNotFoundException extends IONException {
  UserChatRelaysNotFoundException() : super(10040, 'User chat relays not found');
}

class AuthChallengeIsEmptyException extends IONException {
  AuthChallengeIsEmptyException() : super(10041, 'Auth challenge is empty');
}

class DecodeE2EMessageException extends IONException {
  DecodeE2EMessageException() : super(10042, 'Failed to decode E2E message');
}

class ConversationNotFoundException extends IONException {
  ConversationNotFoundException() : super(10043, 'Failed to find conversation');
}

class ParticipantNotFoundException extends IONException {
  ParticipantNotFoundException() : super(10044, 'Failed to find conversation participant');
}

class ConfigPlatformNotSupportException extends IONException {
  ConfigPlatformNotSupportException() : super(10045, 'Platform not supported');
}

class ForceUpdateCouldntLaunchUrlException extends IONException {
  ForceUpdateCouldntLaunchUrlException({required String url})
      : super(10046, 'Could not launch $url');
}

class ForceUpdateFetchConfigException extends IONException {
  ForceUpdateFetchConfigException() : super(10047, 'Failed to get version config');
}

class DeleteEntityUnsupportedTypeException extends IONException {
  DeleteEntityUnsupportedTypeException()
      : super(10048, 'Failed to delete entity, unsupported type');
}

class UnknownEventReferenceType extends IONException {
  UnknownEventReferenceType({required String type})
      : super(10049, 'Unknown event reference type $type');
}

class UnsupportedEventReference extends IONException {
  UnsupportedEventReference(dynamic eventReference)
      : super(10050, 'Unsupported event reference $eventReference');
}

class UnsupportedEntityBookmarking extends IONException {
  UnsupportedEntityBookmarking(dynamic entity) : super(10051, 'Unsupported bookmarking of $entity');
}

class IncorrectEventTagValueException extends IONException {
  IncorrectEventTagValueException({required String tag, required String value})
      : super(10052, 'Incorrect event tag value $tag: $value');
}

class FailedToCreateChannelException extends IONException {
  FailedToCreateChannelException() : super(10053, 'Failed to create channel');
}

class FailedToFetchCommunityException extends IONException {
  FailedToFetchCommunityException(String uuid) : super(10054, 'Failed to fetch community $uuid');
}

class FailedToEditCommunityException extends IONException {
  FailedToEditCommunityException() : super(10055, 'Failed to edit community');
}

class FailedToJoinCommunityException extends IONException {
  FailedToJoinCommunityException() : super(10056, 'Failed to join community');
}

class FailedToSendInvitationException extends IONException {
  FailedToSendInvitationException() : super(10057, 'Failed to send invitation');
}

class CommunityInvitationExpiredException extends IONException {
  CommunityInvitationExpiredException() : super(10058, 'Community invitation expired');
}

class CommunityInvitationNotFoundException extends IONException {
  CommunityInvitationNotFoundException() : super(10059, 'Community invitation not found');
}
