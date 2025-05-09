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
  UserRelaysNotFoundException([String? pubkey])
      : super(
          10004,
          pubkey != null ? 'User relays not found for $pubkey' : 'User relays not found',
        );
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
  IncorrectEventTagException({required Object? tag}) : super(10013, 'Incorrect event tag $tag');
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
  AssetEntityFileNotFoundException({String? assetId})
      : super(
          10100,
          'Asset entity file not found${assetId != null ? ' for asset ID: $assetId' : ''}',
        );
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
  UnknownFileResolutionException(String reason) : super(10026, 'Unknown file resolution: $reason');
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
  ConversationIsNotFoundException(String id)
      : super(10035, 'Failed to find conversation for message: $id');
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
  DecodeE2EMessageException(String id) : super(10042, 'Failed to decode E2E message id: $id');
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

class ForceUpdateFetchConfigException extends IONException {
  ForceUpdateFetchConfigException(dynamic error)
      : super(10047, 'Failed to get version config $error');
}

class DeleteEntityUnsupportedTypeException extends IONException {
  DeleteEntityUnsupportedTypeException()
      : super(10048, 'Failed to delete entity, unsupported type');
}

class UnsupportedEventReference extends IONException {
  UnsupportedEventReference(dynamic eventReference)
      : super(10050, 'Unsupported event reference $eventReference');
}

class UnsupportedEntityBookmarking extends IONException {
  UnsupportedEntityBookmarking(dynamic entity) : super(10051, 'Unsupported bookmarking of $entity');
}

class IncorrectEventTagValueException extends IONException {
  IncorrectEventTagValueException({required String tag, required String? value})
      : super(10052, 'Incorrect event tag value $tag: $value');
}

class FailedToCreateChannelException extends IONException {
  FailedToCreateChannelException() : super(10053, 'Failed to create channel');
}

class FailedToCreateCommunityException extends IONException {
  FailedToCreateCommunityException() : super(10054, 'Failed to create channel');
}

class FailedToFetchCommunityException extends IONException {
  FailedToFetchCommunityException(String uuid) : super(10055, 'Failed to fetch community $uuid');
}

class FailedToEditCommunityException extends IONException {
  FailedToEditCommunityException() : super(10056, 'Failed to edit community');
}

class FailedToJoinCommunityException extends IONException {
  FailedToJoinCommunityException() : super(10057, 'Failed to join community');
}

class FailedToSendInvitationException extends IONException {
  FailedToSendInvitationException() : super(10058, 'Failed to send invitation');
}

class CommunityInvitationExpiredException extends IONException {
  CommunityInvitationExpiredException() : super(10059, 'Community invitation expired');
}

class CommunityInvitationNotFoundException extends IONException {
  CommunityInvitationNotFoundException() : super(10060, 'Community invitation not found');
}

class UpdateWalletViewRequestWithoutDataException extends IONException {
  UpdateWalletViewRequestWithoutDataException()
      : super(
          10061,
          'Cannot create create/update wallet view request without data',
        );
}

class UpdateWalletViewRequestNoUserWalletsException extends IONException {
  UpdateWalletViewRequestNoUserWalletsException()
      : super(
          10062,
          'To build request from coins list user wallets should be provided',
        );
}

class UserMetadataNotFoundException extends IONException {
  UserMetadataNotFoundException(String masterPubkey)
      : super(
          10063,
          'User metadata not found $masterPubkey',
        );
}

class UserPubkeyNotFoundException extends IONException {
  UserPubkeyNotFoundException(String masterPubkey)
      : super(
          10064,
          'User pubkey not found, master pubkey: $masterPubkey',
        );
}

class ReceiverDevicePubkeyNotFoundException extends IONException {
  ReceiverDevicePubkeyNotFoundException(String eventId)
      : super(
          10065,
          'Sender device pubkey not found in event: $eventId',
        );
}

class EventCountException extends IONException {
  EventCountException([String? message])
      : super(
          10066,
          message ?? 'An unexpected error occurred',
        );
}

class ConversationTypeNotFoundException extends IONException {
  ConversationTypeNotFoundException()
      : super(
          10067,
          'Conversation type not found',
        );
}

class FailedToDecryptFileException extends IONException {
  FailedToDecryptFileException()
      : super(
          10068,
          'Failed to decrypt file',
        );
}

class ParticipantsMasterPubkeysNotFoundException extends IONException {
  ParticipantsMasterPubkeysNotFoundException(String id)
      : super(
          10069,
          'Event id $id',
        );
}

class CannotBuildTransferForUnknownAssetException extends IONException {
  CannotBuildTransferForUnknownAssetException(String kind)
      : super(
          10070,
          'Cannot build transfer for unknown asset kind: $kind',
        );
}

class UnknownNetworkException extends IONException {
  UnknownNetworkException(String network)
      : super(
          10071,
          'Unknown network: $network',
        );
}

class AnonymousRelayAuthException extends IONException {
  AnonymousRelayAuthException() : super(10071, 'Auth required error in anonymous relay');
}

class PubkeysDoNotMatchException extends IONException {
  PubkeysDoNotMatchException() : super(10072, 'Pubkeys do not match');
}

class CloudPermissionFailedException extends IONException {
  CloudPermissionFailedException()
      : super(10073, 'Not signed in for cloud account or permission denied');
}

class CloudFilesGatherFailedException extends IONException {
  CloudFilesGatherFailedException(dynamic error)
      : super(10074, 'Files gather from cloud failed, error: $error');
}

class CloudFileUploadFailedException extends IONException {
  CloudFileUploadFailedException(dynamic error)
      : super(10075, 'File upload to cloud failed, error: $error');
}

class CloudUploadedFileNotFoundException extends IONException {
  CloudUploadedFileNotFoundException()
      : super(10076, 'Cloud upload failed - uploaded file not found');
}

class CloudFileDownloadFailedException extends IONException {
  CloudFileDownloadFailedException(dynamic error)
      : super(10077, 'File download from cloud failed, error: $error');
}

class RecoveryKeysFileDoesNotExistException extends IONException {
  RecoveryKeysFileDoesNotExistException() : super(10078, 'Recovery keys file does not exist');
}

class RecoveryKeysRestoreFailedException extends IONException {
  RecoveryKeysRestoreFailedException(dynamic error)
      : super(10079, 'Recovery keys restore failed, error: $error');
}

class RecoveryKeysRestoreIncorrectPasswordException extends IONException {
  RecoveryKeysRestoreIncorrectPasswordException()
      : super(10080, 'Recovery keys restore incorrect password');
}

class ShareableIdentifierDecodeException extends IONException {
  ShareableIdentifierDecodeException(String identifier)
      : super(10081, 'Failed to decode $identifier');
}

class IncorrectShareableIdentifierException extends IONException {
  IncorrectShareableIdentifierException(dynamic identifier)
      : super(10082, 'Incorrect shareable identifier $identifier');
}

class CloudFileDeleteFailedException extends IONException {
  CloudFileDeleteFailedException(dynamic error)
      : super(10083, 'File delete from cloud failed, error: $error');
}

class NftNotFoundException extends IONException {
  NftNotFoundException(String tokenId) : super(10084, 'Nft not found: $tokenId');
}

class CurrentWalletViewNotFoundException extends IONException {
  CurrentWalletViewNotFoundException() : super(10085, 'Current wallet view not found');
}

class FailedToSendCryptoAssetsException extends IONException {
  FailedToSendCryptoAssetsException(String? reason)
      : super(10086, reason ?? 'Failed to send crypto assets');
}

class UnknownNotificationCommentException extends IONException {
  UnknownNotificationCommentException([Object? info])
      : super(10087, 'Unknown notification comment type $info');
}

class MediaThumbnailNotFoundException extends IONException {
  MediaThumbnailNotFoundException() : super(10088, 'Media thumbnail not found');
}

class MediaBlurhashCannotBeGeneratedException extends IONException {
  MediaBlurhashCannotBeGeneratedException(String? mimeType, {dynamic error})
      : super(10089, 'Media blurhash cannot be generated for $mimeType: $error');
}

class FileDeleteException extends IONException {
  FileDeleteException(dynamic error, {required String fileHash})
      : super(10090, 'Failed to delete file $fileHash: $error');
}

class FormException extends IONException {
  FormException(dynamic error, {String? formName})
      : super(10091, 'Form ${formName ?? '<not specified>'} issue: $error');
}

class FailedToSendEmail extends IONException {
  FailedToSendEmail() : super(10092, 'Unable to send email');
}

class WalletsLoadingException extends IONException {
  WalletsLoadingException() : super(10093, 'Failed to load wallets');
}

class FailedToGenerateMediaUrlFallback extends IONException {
  FailedToGenerateMediaUrlFallback() : super(10094, 'Failed to generate media fallback url');
}

class ReplaceablePrivateDirectMessageDecodeException extends IONException {
  ReplaceablePrivateDirectMessageDecodeException(String id)
      : super(10096, 'Failed to convert event message with id $id');
}

class GetRelayInfoException extends IONException {
  GetRelayInfoException(dynamic error, {required String relayUrl})
      : super(10097, 'Failed to get relay info for $relayUrl, $error');
}

class RelayUnreachableException extends IONException {
  RelayUnreachableException(this.relayUrl) : super(10099, 'Unable to connect to relay: $relayUrl');

  final String relayUrl;
}

class UserEventsMetadataBuilderException extends IONException {
  UserEventsMetadataBuilderException()
      : super(10100, 'Unable to create user events metadata builder');
}

class GetPushTranslationsException extends IONException {
  GetPushTranslationsException(dynamic error)
      : super(10101, 'Failed to get push translations: $error');
}
