// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'paged.freezed.dart';

@freezed
class PaginationParams with _$PaginationParams {
  factory PaginationParams({
    @Default(true) bool hasMore,
    DateTime? lastEventTime,
  }) = _PaginationParams;

  PaginationParams._();

  // Adding 1 second because otherwise events might be unintentionally skipped
  DateTime? get until => lastEventTime?.add(const Duration(seconds: 1));
}

@freezed
sealed class Paged<T> with _$Paged<T> {
  const factory Paged.loading(
    Set<T> items, {
    required PaginationParams pagination,
  }) = PagedLoading;
  const factory Paged.data(
    Set<T> items, {
    required PaginationParams pagination,
  }) = PagedData;
  const factory Paged.error(
    Set<T> items, {
    required Object error,
    required PaginationParams pagination,
  }) = PagedError;
}
