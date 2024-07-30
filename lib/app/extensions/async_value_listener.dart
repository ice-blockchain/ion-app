import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueListener on WidgetRef {
  void listenAsyncValue<TSuccess>(
    ProviderListenable<AsyncValue<TSuccess?>> provider, {
    void Function()? onLoading,
    void Function(TSuccess? response)? onSuccess,
    void Function(Object erorr, StackTrace stackTrace)? onFailure,
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
  }) {
    listen(provider, (previous, next) {
      next.whenOrNull(
        loading: onLoading,
        data: onSuccess,
        error: onFailure,
        skipError: skipError,
        skipLoadingOnRefresh: skipLoadingOnRefresh,
        skipLoadingOnReload: skipLoadingOnReload,
      );
    });
  }
}
