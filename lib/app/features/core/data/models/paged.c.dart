// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'paged.c.freezed.dart';

@freezed
class PaginationParams with _$PaginationParams {
  factory PaginationParams({
    @Default(true) bool hasMore,
    DateTime? lastEventTime,
  }) = _PaginationParams;

  PaginationParams._();

  // Adding 2 microseconds because otherwise events might be unintentionally skipped
  DateTime? get until => lastEventTime?.add(const Duration(microseconds: 2));
}

@freezed
sealed class Paged<T, P> with _$Paged<T, P> {
  const factory Paged.loading(
    Set<T>? items, {
    required P pagination,
  }) = PagedLoading;
  const factory Paged.data(
    Set<T>? items, {
    required P pagination,
  }) = PagedData;
  const factory Paged.error(
    Set<T>? items, {
    required Object error,
    required P pagination,
  }) = PagedError;
}
