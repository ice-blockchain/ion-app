import 'package:ion_identity_client/src/core/types/types.dart';

sealed class NetworkFailure {
  const NetworkFailure();
}

final class RequestExecutionNetworkFailure extends NetworkFailure {
  RequestExecutionNetworkFailure(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

final class ResponseFormatNetworkFailure extends NetworkFailure {
  const ResponseFormatNetworkFailure(this.response);

  final dynamic response;
}

final class DecodeNetworkFailure extends NetworkFailure {
  const DecodeNetworkFailure(this.map);

  final JsonObject map;
}
