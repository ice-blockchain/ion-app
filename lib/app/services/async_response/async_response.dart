import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'async_response.freezed.dart';

@freezed
class AsyncResponse<TSuccess> with _$AsyncResponse<TSuccess> {
  const AsyncResponse._();

  const factory AsyncResponse.initial() = _AsyncResponseInitial;

  const factory AsyncResponse.loading() = _AsyncResponseLoading;

  const factory AsyncResponse.success(TSuccess? payload) = _AsyncResponseSuccess;

  const factory AsyncResponse.failure(Exception e) = _AsyncResponseFailure;

  bool get isLoading => this is _AsyncResponseLoading;

  bool get isFailure => this is _AsyncResponseFailure;

  bool get isSuccess => this is _AsyncResponseSuccess;
}

extension AsyncResponseListener on WidgetRef {
  void listenAsyncResponse<TSuccess>(
    ProviderListenable<AsyncResponse<TSuccess>> provider, {
    void Function()? onInitial,
    void Function()? onLoading,
    void Function(TSuccess? response)? onSuccess,
    void Function(Exception e)? onFailure,
  }) {
    listen(provider, (previous, next) {
      next.whenOrNull(
        initial: onInitial,
        loading: onLoading,
        success: onSuccess,
        failure: onFailure,
      );
    });
  }
}
