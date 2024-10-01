// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/core/network/network_failure.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

typedef Decoder<T> = T Function(JsonObject response);

/// A generic network client that wraps around Dio and provides methods for
/// making GET and POST requests with automatic error handling and decoding
/// of JSON responses into typed results.
class NetworkClient {
  /// Creates an instance of [NetworkClient] with the provided Dio instance.
  /// This Dio instance is used to perform the actual network requests.
  NetworkClient({
    required this.dio,
  });

  /// The Dio instance used to perform network requests.
  final Dio dio;

  /// Sends a GET request to the specified [path] with optional [queryParams],
  /// and decodes the JSON response into a [Result] using the provided [decoder].
  ///
  /// Returns a [TaskEither] that either contains a [NetworkFailure] or the
  /// decoded [Result].
  TaskEither<NetworkFailure, Result> get<Result>(
    String path, {
    required Decoder<Result> decoder,
    JsonObject queryParams = const {},
    JsonObject headers = const {},
  }) {
    return _makeRequest(
      request: () => dio.get<JsonObject>(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers),
      ),
      decoder: decoder,
    );
  }

  /// Sends a POST request to the specified [path] with optional [queryParams]
  /// and request [data], and decodes the JSON response into a [Result] using
  /// the provided [decoder].
  ///
  /// Returns a [TaskEither] that either contains a [NetworkFailure] or the
  /// decoded [Result].
  TaskEither<NetworkFailure, Result> post<Result>(
    String path, {
    required Decoder<Result> decoder,
    JsonObject queryParams = const {},
    JsonObject headers = const {},
    Object? data,
  }) {
    return _makeRequest(
      request: () => dio.post<JsonObject>(
        path,
        queryParameters: queryParams,
        data: data,
        options: Options(headers: headers),
      ),
      decoder: decoder,
    );
  }

  /// A private method that executes the provided [request] function, handles
  /// potential errors, and decodes the JSON response using the provided [decoder].
  ///
  /// Returns a [TaskEither] that either contains a [NetworkFailure] or the
  /// decoded [Result].
  TaskEither<NetworkFailure, Result> _makeRequest<Result>({
    required Future<Response<JsonObject>> Function() request,
    required Decoder<Result> decoder,
  }) {
    return TaskEither<NetworkFailure, dynamic>.tryCatch(
      request,
      RequestExecutionNetworkFailure.new,
    )
        .flatMap(
          (response) => Either.tryCatch(
            () => response.data as Map<String, dynamic>,
            (_, __) => ResponseFormatNetworkFailure(response.data),
          ).toTaskEither(),
        )
        .flatMap(
          (r) => Either.tryCatch(
            () => decoder(r),
            (error, stackTrace) => DecodeNetworkFailure(r, error, stackTrace),
          ).toTaskEither(),
        );
  }
}
