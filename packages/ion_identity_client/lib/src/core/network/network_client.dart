// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:ion_identity_client/src/core/network/network_exception.dart';
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
  /// Throws a [NetworkException] if the request fails or the response cannot be decoded.
  Future<Result> get<Result>(
    String path, {
    required Decoder<Result> decoder,
    JsonObject queryParams = const {},
    JsonObject headers = const {},
  }) async {
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
  /// Throws a [NetworkException] if the request fails or the response cannot be decoded.
  Future<Result> post<Result>(
    String path, {
    required Decoder<Result> decoder,
    JsonObject queryParams = const {},
    JsonObject headers = const {},
    Object? data,
  }) async {
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

  Future<Result> patch<Result>(
    String path, {
    required Decoder<Result> decoder,
    JsonObject queryParams = const {},
    JsonObject headers = const {},
    Object? data,
  }) async {
    return _makeRequest(
      request: () => dio.patch<JsonObject>(
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
  /// Throws a [NetworkException] if the request fails or the response cannot be decoded.
  Future<Result> _makeRequest<Result>({
    required Future<Response<JsonObject>> Function() request,
    required Decoder<Result> decoder,
  }) async {
    try {
      final response = await request();
      final data = response.data;

      if (data == null) {
        throw ResponseFormatException(data);
      }

      try {
        return decoder(data);
      } catch (e, stackTrace) {
        throw DecodeException(data, e, stackTrace);
      }
    } on DioException catch (e, stackTrace) {
      throw RequestExecutionException(e, stackTrace);
    } on NetworkException {
      rethrow;
    } catch (e, stackTrace) {
      throw RequestExecutionException(e, stackTrace);
    }
  }
}
