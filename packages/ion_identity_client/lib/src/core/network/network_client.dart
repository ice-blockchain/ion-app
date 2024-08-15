import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/core/network/network_failure.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

typedef Decoder<T> = T Function(Response<JsonObject> response);

class NetworkClient {
  NetworkClient({
    required this.dio,
  });

  final Dio dio;

  TaskEither<NetworkFailure, Result> get<Result>(
    String path, {
    required Decoder<Result> decoder,
    JsonObject queryParams = const {},
  }) {
    return _makeRequest(
      request: () => dio.get<JsonObject>(
        path,
        queryParameters: queryParams,
      ),
      decoder: decoder,
    );
  }

  TaskEither<NetworkFailure, Result> post<Result>(
    String path, {
    required Decoder<Result> decoder,
    JsonObject queryParams = const {},
    Object? data,
  }) {
    return _makeRequest(
      request: () => dio.post<JsonObject>(
        path,
        queryParameters: queryParams,
        data: data,
      ),
      decoder: decoder,
    );
  }

  TaskEither<NetworkFailure, Result> _makeRequest<Result>({
    required Future<Response<JsonObject>> Function() request,
    required Decoder<Result> decoder,
  }) {
    return TaskEither.tryCatch(
      () async {
        final response = await request();

        final failure = _handleError<Result>();
        // TODO: how to handle failure that is not exception?
        if (failure != null) {
          throw Exception(failure.error);
        }

        final decodedResponse = decoder(response);

        return decodedResponse;
      },
      NetworkFailure.new,
    );
  }

  NetworkFailure? _handleError<T>() {
    return null;
  }
}
