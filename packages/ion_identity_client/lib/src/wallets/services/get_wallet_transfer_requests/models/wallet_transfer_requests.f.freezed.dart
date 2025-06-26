// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_transfer_requests.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletTransferRequests _$WalletTransferRequestsFromJson(
    Map<String, dynamic> json) {
  return _WalletTransferRequests.fromJson(json);
}

/// @nodoc
mixin _$WalletTransferRequests {
  String get walletId => throw _privateConstructorUsedError;
  List<WalletTransferRequest> get items => throw _privateConstructorUsedError;
  String? get nextPageToken => throw _privateConstructorUsedError;

  /// Serializes this WalletTransferRequests to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletTransferRequests
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletTransferRequestsCopyWith<WalletTransferRequests> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletTransferRequestsCopyWith<$Res> {
  factory $WalletTransferRequestsCopyWith(WalletTransferRequests value,
          $Res Function(WalletTransferRequests) then) =
      _$WalletTransferRequestsCopyWithImpl<$Res, WalletTransferRequests>;
  @useResult
  $Res call(
      {String walletId,
      List<WalletTransferRequest> items,
      String? nextPageToken});
}

/// @nodoc
class _$WalletTransferRequestsCopyWithImpl<$Res,
        $Val extends WalletTransferRequests>
    implements $WalletTransferRequestsCopyWith<$Res> {
  _$WalletTransferRequestsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletTransferRequests
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletId = null,
    Object? items = null,
    Object? nextPageToken = freezed,
  }) {
    return _then(_value.copyWith(
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WalletTransferRequest>,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletTransferRequestsImplCopyWith<$Res>
    implements $WalletTransferRequestsCopyWith<$Res> {
  factory _$$WalletTransferRequestsImplCopyWith(
          _$WalletTransferRequestsImpl value,
          $Res Function(_$WalletTransferRequestsImpl) then) =
      __$$WalletTransferRequestsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String walletId,
      List<WalletTransferRequest> items,
      String? nextPageToken});
}

/// @nodoc
class __$$WalletTransferRequestsImplCopyWithImpl<$Res>
    extends _$WalletTransferRequestsCopyWithImpl<$Res,
        _$WalletTransferRequestsImpl>
    implements _$$WalletTransferRequestsImplCopyWith<$Res> {
  __$$WalletTransferRequestsImplCopyWithImpl(
      _$WalletTransferRequestsImpl _value,
      $Res Function(_$WalletTransferRequestsImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletTransferRequests
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletId = null,
    Object? items = null,
    Object? nextPageToken = freezed,
  }) {
    return _then(_$WalletTransferRequestsImpl(
      walletId: null == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WalletTransferRequest>,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletTransferRequestsImpl implements _WalletTransferRequests {
  const _$WalletTransferRequestsImpl(
      {required this.walletId,
      required final List<WalletTransferRequest> items,
      this.nextPageToken})
      : _items = items;

  factory _$WalletTransferRequestsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletTransferRequestsImplFromJson(json);

  @override
  final String walletId;
  final List<WalletTransferRequest> _items;
  @override
  List<WalletTransferRequest> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextPageToken;

  @override
  String toString() {
    return 'WalletTransferRequests(walletId: $walletId, items: $items, nextPageToken: $nextPageToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletTransferRequestsImpl &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextPageToken, nextPageToken) ||
                other.nextPageToken == nextPageToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, walletId,
      const DeepCollectionEquality().hash(_items), nextPageToken);

  /// Create a copy of WalletTransferRequests
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletTransferRequestsImplCopyWith<_$WalletTransferRequestsImpl>
      get copyWith => __$$WalletTransferRequestsImplCopyWithImpl<
          _$WalletTransferRequestsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletTransferRequestsImplToJson(
      this,
    );
  }
}

abstract class _WalletTransferRequests implements WalletTransferRequests {
  const factory _WalletTransferRequests(
      {required final String walletId,
      required final List<WalletTransferRequest> items,
      final String? nextPageToken}) = _$WalletTransferRequestsImpl;

  factory _WalletTransferRequests.fromJson(Map<String, dynamic> json) =
      _$WalletTransferRequestsImpl.fromJson;

  @override
  String get walletId;
  @override
  List<WalletTransferRequest> get items;
  @override
  String? get nextPageToken;

  /// Create a copy of WalletTransferRequests
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletTransferRequestsImplCopyWith<_$WalletTransferRequestsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
