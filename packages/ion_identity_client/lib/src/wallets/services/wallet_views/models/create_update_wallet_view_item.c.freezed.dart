// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_update_wallet_view_item.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateUpdateWalletViewItem _$CreateUpdateWalletViewItemFromJson(
    Map<String, dynamic> json) {
  return _CreateUpdateWalletViewItem.fromJson(json);
}

/// @nodoc
mixin _$CreateUpdateWalletViewItem {
  String get coinId => throw _privateConstructorUsedError;
  String? get walletId => throw _privateConstructorUsedError;

  /// Serializes this CreateUpdateWalletViewItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateUpdateWalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateUpdateWalletViewItemCopyWith<CreateUpdateWalletViewItem>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateUpdateWalletViewItemCopyWith<$Res> {
  factory $CreateUpdateWalletViewItemCopyWith(CreateUpdateWalletViewItem value,
          $Res Function(CreateUpdateWalletViewItem) then) =
      _$CreateUpdateWalletViewItemCopyWithImpl<$Res,
          CreateUpdateWalletViewItem>;
  @useResult
  $Res call({String coinId, String? walletId});
}

/// @nodoc
class _$CreateUpdateWalletViewItemCopyWithImpl<$Res,
        $Val extends CreateUpdateWalletViewItem>
    implements $CreateUpdateWalletViewItemCopyWith<$Res> {
  _$CreateUpdateWalletViewItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateUpdateWalletViewItem
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
abstract class _$$CreateUpdateWalletViewItemImplCopyWith<$Res>
    implements $CreateUpdateWalletViewItemCopyWith<$Res> {
  factory _$$CreateUpdateWalletViewItemImplCopyWith(
          _$CreateUpdateWalletViewItemImpl value,
          $Res Function(_$CreateUpdateWalletViewItemImpl) then) =
      __$$CreateUpdateWalletViewItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String coinId, String? walletId});
}

/// @nodoc
class __$$CreateUpdateWalletViewItemImplCopyWithImpl<$Res>
    extends _$CreateUpdateWalletViewItemCopyWithImpl<$Res,
        _$CreateUpdateWalletViewItemImpl>
    implements _$$CreateUpdateWalletViewItemImplCopyWith<$Res> {
  __$$CreateUpdateWalletViewItemImplCopyWithImpl(
      _$CreateUpdateWalletViewItemImpl _value,
      $Res Function(_$CreateUpdateWalletViewItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateUpdateWalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinId = null,
    Object? walletId = freezed,
  }) {
    return _then(_$CreateUpdateWalletViewItemImpl(
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
class _$CreateUpdateWalletViewItemImpl implements _CreateUpdateWalletViewItem {
  const _$CreateUpdateWalletViewItemImpl({required this.coinId, this.walletId});

  factory _$CreateUpdateWalletViewItemImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateUpdateWalletViewItemImplFromJson(json);

  @override
  final String coinId;
  @override
  final String? walletId;

  @override
  String toString() {
    return 'CreateUpdateWalletViewItem(coinId: $coinId, walletId: $walletId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUpdateWalletViewItemImpl &&
            (identical(other.coinId, coinId) || other.coinId == coinId) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, coinId, walletId);

  /// Create a copy of CreateUpdateWalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUpdateWalletViewItemImplCopyWith<_$CreateUpdateWalletViewItemImpl>
      get copyWith => __$$CreateUpdateWalletViewItemImplCopyWithImpl<
          _$CreateUpdateWalletViewItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateUpdateWalletViewItemImplToJson(
      this,
    );
  }
}

abstract class _CreateUpdateWalletViewItem
    implements CreateUpdateWalletViewItem {
  const factory _CreateUpdateWalletViewItem(
      {required final String coinId,
      final String? walletId}) = _$CreateUpdateWalletViewItemImpl;

  factory _CreateUpdateWalletViewItem.fromJson(Map<String, dynamic> json) =
      _$CreateUpdateWalletViewItemImpl.fromJson;

  @override
  String get coinId;
  @override
  String? get walletId;

  /// Create a copy of CreateUpdateWalletViewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUpdateWalletViewItemImplCopyWith<_$CreateUpdateWalletViewItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}
