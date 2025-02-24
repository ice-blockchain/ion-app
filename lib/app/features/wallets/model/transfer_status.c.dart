import 'package:freezed_annotation/freezed_annotation.dart';

enum TransferStatus {
  /// The request is pending approval due to a policy applied to the wallet
  @JsonValue('Pending')
  pending,

  /// The request is approved and is in the process of being executed
  /// (note this status is only set for a short time between pending and broadcasted)
  @JsonValue('Executing')
  executing,

  /// The transaction has been successfully written to the mempool
  @JsonValue('Broadcasted')
  broadcasted,

  /// The transaction has been confirmed on-chain by our indexing pipeline
  @JsonValue('Confirmed')
  confirmed,

  /// Indicates a system failure to complete the request
  @JsonValue('Failed')
  failed,

  /// The request has been rejected by a policy approval action
  @JsonValue('Rejected')
  rejected;
}
