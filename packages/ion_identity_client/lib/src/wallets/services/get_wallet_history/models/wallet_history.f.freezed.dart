// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_history.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletHistory _$WalletHistoryFromJson(Map<String, dynamic> json) {
  return _WalletHistory.fromJson(json);
}

/// @nodoc
mixin _$WalletHistory {
  List<WalletHistoryRecord> get items => throw _privateConstructorUsedError;
  String? get nextPageToken => throw _privateConstructorUsedError;

  /// Serializes this WalletHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletHistoryCopyWith<WalletHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletHistoryCopyWith<$Res> {
  factory $WalletHistoryCopyWith(
          WalletHistory value, $Res Function(WalletHistory) then) =
      _$WalletHistoryCopyWithImpl<$Res, WalletHistory>;
  @useResult
  $Res call({List<WalletHistoryRecord> items, String? nextPageToken});
}

/// @nodoc
class _$WalletHistoryCopyWithImpl<$Res, $Val extends WalletHistory>
    implements $WalletHistoryCopyWith<$Res> {
  _$WalletHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextPageToken = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WalletHistoryRecord>,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletHistoryImplCopyWith<$Res>
    implements $WalletHistoryCopyWith<$Res> {
  factory _$$WalletHistoryImplCopyWith(
          _$WalletHistoryImpl value, $Res Function(_$WalletHistoryImpl) then) =
      __$$WalletHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<WalletHistoryRecord> items, String? nextPageToken});
}

/// @nodoc
class __$$WalletHistoryImplCopyWithImpl<$Res>
    extends _$WalletHistoryCopyWithImpl<$Res, _$WalletHistoryImpl>
    implements _$$WalletHistoryImplCopyWith<$Res> {
  __$$WalletHistoryImplCopyWithImpl(
      _$WalletHistoryImpl _value, $Res Function(_$WalletHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextPageToken = freezed,
  }) {
    return _then(_$WalletHistoryImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WalletHistoryRecord>,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletHistoryImpl implements _WalletHistory {
  const _$WalletHistoryImpl(
      {required final List<WalletHistoryRecord> items, this.nextPageToken})
      : _items = items;

  factory _$WalletHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletHistoryImplFromJson(json);

  final List<WalletHistoryRecord> _items;
  @override
  List<WalletHistoryRecord> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextPageToken;

  @override
  String toString() {
    return 'WalletHistory(items: $items, nextPageToken: $nextPageToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletHistoryImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextPageToken, nextPageToken) ||
                other.nextPageToken == nextPageToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextPageToken);

  /// Create a copy of WalletHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletHistoryImplCopyWith<_$WalletHistoryImpl> get copyWith =>
      __$$WalletHistoryImplCopyWithImpl<_$WalletHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletHistoryImplToJson(
      this,
    );
  }
}

abstract class _WalletHistory implements WalletHistory {
  const factory _WalletHistory(
      {required final List<WalletHistoryRecord> items,
      final String? nextPageToken}) = _$WalletHistoryImpl;

  factory _WalletHistory.fromJson(Map<String, dynamic> json) =
      _$WalletHistoryImpl.fromJson;

  @override
  List<WalletHistoryRecord> get items;
  @override
  String? get nextPageToken;

  /// Create a copy of WalletHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletHistoryImplCopyWith<_$WalletHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
