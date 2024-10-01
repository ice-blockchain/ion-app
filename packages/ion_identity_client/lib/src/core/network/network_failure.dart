// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';

/// A sealed class representing different types of failures that can occur
/// during network operations. This serves as the base class for all specific
/// network failure types.
sealed class NetworkFailure {
  const NetworkFailure();
}

/// Represents a failure that occurs during the execution of a network request,
/// such as connection issues or request timeouts.
final class RequestExecutionNetworkFailure extends NetworkFailure {
  RequestExecutionNetworkFailure(this.error, this.stackTrace);

  /// The underlying error that caused the network request to fail.
  final Object error;

  /// The stack trace at the point where the error occurred, useful for debugging.
  final StackTrace stackTrace;
}

/// Represents a failure due to an unexpected response format from the network request.
/// This can happen when the response does not match the expected JSON structure.
final class ResponseFormatNetworkFailure extends NetworkFailure {
  const ResponseFormatNetworkFailure(this.response);

  /// The raw response data that could not be correctly parsed or processed.
  final dynamic response;
}

/// Represents a failure that occurs during the decoding of a JSON response
/// into a Dart object. This typically happens when the JSON structure does not
/// match the expected model.
final class DecodeNetworkFailure extends NetworkFailure {
  const DecodeNetworkFailure(this.map, this.error, this.stackTrace);

  /// The JSON object that failed to decode into the expected Dart object.
  final JsonObject map;
  final Object error;
  final StackTrace stackTrace;
}
