// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_view_item.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletViewItem _$WalletViewItemFromJson(Map<String, dynamic> json) {
  return _WalletViewItem.fromJson(json);
}

/// @nodoc
mixin _$WalletViewItem {
  String get coinId => throw _privateConstructorUsedError;
  String? get walletId => throw _privateConstructorUsedError;

  /// Serializes this WalletViewItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletViewItemCopyWith<WalletViewItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletViewItemCopyWith<$Res> {
  factory $WalletViewItemCopyWith(
          WalletViewItem value, $Res Function(WalletViewItem) then) =
      _$WalletViewItemCopyWithImpl<$Res, WalletViewItem>;
  @useResult
  $Res call({String coinId, String? walletId});
}

/// @nodoc
class _$WalletViewItemCopyWithImpl<$Res, $Val extends WalletViewItem>
    implements $WalletViewItemCopyWith<$Res> {
  _$WalletViewItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinId = null,
    Object? walletId = freezed,
  }) {
    return _then(_value.copyWith(
      coinId: null == coinId
          ? _value.coinId
          : coinId // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: freezed == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletViewItemImplCopyWith<$Res>
    implements $WalletViewItemCopyWith<$Res> {
  factory _$$WalletViewItemImplCopyWith(_$WalletViewItemImpl value,
          $Res Function(_$WalletViewItemImpl) then) =
      __$$WalletViewItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String coinId, String? walletId});
}

/// @nodoc
class __$$WalletViewItemImplCopyWithImpl<$Res>
    extends _$WalletViewItemCopyWithImpl<$Res, _$WalletViewItemImpl>
    implements _$$WalletViewItemImplCopyWith<$Res> {
  __$$WalletViewItemImplCopyWithImpl(
      _$WalletViewItemImpl _value, $Res Function(_$WalletViewItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinId = null,
    Object? walletId = freezed,
  }) {
    return _then(_$WalletViewItemImpl(
      coinId: null == coinId
          ? _value.coinId
          : coinId // ignore: cast_nullable_to_non_nullable
              as String,
      walletId: freezed == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletViewItemImpl implements _WalletViewItem {
  const _$WalletViewItemImpl({required this.coinId, this.walletId});

  factory _$WalletViewItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletViewItemImplFromJson(json);

  @override
  final String coinId;
  @override
  final String? walletId;

  @override
  String toString() {
    return 'WalletViewItem(coinId: $coinId, walletId: $walletId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletViewItemImpl &&
            (identical(other.coinId, coinId) || other.coinId == coinId) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, coinId, walletId);

  /// Create a copy of WalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletViewItemImplCopyWith<_$WalletViewItemImpl> get copyWith =>
      __$$WalletViewItemImplCopyWithImpl<_$WalletViewItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletViewItemImplToJson(
      this,
    );
  }
}

abstract class _WalletViewItem implements WalletViewItem {
  const factory _WalletViewItem(
      {required final String coinId,
      final String? walletId}) = _$WalletViewItemImpl;

  factory _WalletViewItem.fromJson(Map<String, dynamic> json) =
      _$WalletViewItemImpl.fromJson;

  @override
  String get coinId;
  @override
  String? get walletId;

  /// Create a copy of WalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletViewItemImplCopyWith<_$WalletViewItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
