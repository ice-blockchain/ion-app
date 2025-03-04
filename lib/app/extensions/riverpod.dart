// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/pages/error_modal.dart';

extension DebounceExtension on Ref {
  Future<void> debounce({Duration duration = const Duration(milliseconds: 300)}) {
    final completer = Completer<void>();
    final timer = Timer(duration, () {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    onDispose(() {
      timer.cancel();
      if (!completer.isCompleted) {
        completer.completeError(StateError('cancelled'));
      }
    });

    return completer.future;
  }
}

extension DisplayErrorsExtension on WidgetRef {
  void displayErrors<T>(
    ProviderListenable<AsyncValue<T>> provider, {
    Set<Type> excludedExceptions = const {},
  }) {
    listen(provider, (_, next) {
      final error = next.error;
      if (!next.isLoading &&
          next.hasError &&
          error != null &&
          context.isCurrentRoute &&
          context.mounted &&
          !excludedExceptions.contains(error.runtimeType)) {
        showErrorModal(context, error);
      }
    });
  }

  void displayErrorsForState<S>(ProviderListenable<dynamic> provider) {
    listen(provider, (prev, next) {
      if (prev is! S && next is S && context.isCurrentRoute && context.mounted) {
        showErrorModal(context, next as Object);
      }
    });
  }
}

extension ListenResultExtension on WidgetRef {
  void listenError<T>(
    ProviderListenable<AsyncValue<T>> provider,
    ValueChanged<Object?> onError,
  ) {
    listen(provider, (prev, next) {
      if (prev?.isLoading != true || next.isLoading == true || !context.isCurrentRoute) {
        return;
      }

      if (next.hasError) {
        onError(next.error);
      }
    });
  }

  void listenSuccess<T>(
    ProviderListenable<AsyncValue<T>> provider,
    ValueChanged<T?> onSuccess,
  ) {
    listen(provider, (prev, next) => _handleOnSuccess(provider, prev, next, onSuccess));
  }

  void listenSuccessManual<T>(
    ProviderListenable<AsyncValue<T>> provider,
    ValueChanged<T?> onSuccess,
  ) {
    listenManual(provider, (prev, next) => _handleOnSuccess(provider, prev, next, onSuccess));
  }

  void _handleOnSuccess<T>(
    ProviderListenable<AsyncValue<T>> provider,
    AsyncValue<T>? prev,
    AsyncValue<T> next,
    ValueChanged<T?> onSuccess,
  ) {
    if (prev?.isLoading != true || next.isLoading == true || !context.isCurrentRoute) {
      return;
    }

    if (next is AsyncData) {
      onSuccess(next.value);
    }
  }
}
