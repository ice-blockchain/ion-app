// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_view_aggregation_item.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletViewAggregationItem _$WalletViewAggregationItemFromJson(
    Map<String, dynamic> json) {
  return _WalletViewAggregationItem.fromJson(json);
}

/// @nodoc
mixin _$WalletViewAggregationItem {
  @JsonKey(defaultValue: [])
  List<WalletViewAggregationWallet> get wallets =>
      throw _privateConstructorUsedError;
  @NumberToStringConverter()
  String get totalBalance => throw _privateConstructorUsedError;

  /// Serializes this WalletViewAggregationItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletViewAggregationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletViewAggregationItemCopyWith<WalletViewAggregationItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletViewAggregationItemCopyWith<$Res> {
  factory $WalletViewAggregationItemCopyWith(WalletViewAggregationItem value,
          $Res Function(WalletViewAggregationItem) then) =
      _$WalletViewAggregationItemCopyWithImpl<$Res, WalletViewAggregationItem>;
  @useResult
  $Res call(
      {@JsonKey(defaultValue: []) List<WalletViewAggregationWallet> wallets,
      @NumberToStringConverter() String totalBalance});
}

/// @nodoc
class _$WalletViewAggregationItemCopyWithImpl<$Res,
        $Val extends WalletViewAggregationItem>
    implements $WalletViewAggregationItemCopyWith<$Res> {
  _$WalletViewAggregationItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletViewAggregationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wallets = null,
    Object? totalBalance = null,
  }) {
    return _then(_value.copyWith(
      wallets: null == wallets
          ? _value.wallets
          : wallets // ignore: cast_nullable_to_non_nullable
              as List<WalletViewAggregationWallet>,
      totalBalance: null == totalBalance
          ? _value.totalBalance
          : totalBalance // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletViewAggregationItemImplCopyWith<$Res>
    implements $WalletViewAggregationItemCopyWith<$Res> {
  factory _$$WalletViewAggregationItemImplCopyWith(
          _$WalletViewAggregationItemImpl value,
          $Res Function(_$WalletViewAggregationItemImpl) then) =
      __$$WalletViewAggregationItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(defaultValue: []) List<WalletViewAggregationWallet> wallets,
      @NumberToStringConverter() String totalBalance});
}

/// @nodoc
class __$$WalletViewAggregationItemImplCopyWithImpl<$Res>
    extends _$WalletViewAggregationItemCopyWithImpl<$Res,
        _$WalletViewAggregationItemImpl>
    implements _$$WalletViewAggregationItemImplCopyWith<$Res> {
  __$$WalletViewAggregationItemImplCopyWithImpl(
      _$WalletViewAggregationItemImpl _value,
      $Res Function(_$WalletViewAggregationItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletViewAggregationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wallets = null,
    Object? totalBalance = null,
  }) {
    return _then(_$WalletViewAggregationItemImpl(
      wallets: null == wallets
          ? _value._wallets
          : wallets // ignore: cast_nullable_to_non_nullable
              as List<WalletViewAggregationWallet>,
      totalBalance: null == totalBalance
          ? _value.totalBalance
          : totalBalance // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletViewAggregationItemImpl implements _WalletViewAggregationItem {
  const _$WalletViewAggregationItemImpl(
      {@JsonKey(defaultValue: [])
      required final List<WalletViewAggregationWallet> wallets,
      @NumberToStringConverter() required this.totalBalance})
      : _wallets = wallets;

  factory _$WalletViewAggregationItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletViewAggregationItemImplFromJson(json);

  final List<WalletViewAggregationWallet> _wallets;
  @override
  @JsonKey(defaultValue: [])
  List<WalletViewAggregationWallet> get wallets {
    if (_wallets is EqualUnmodifiableListView) return _wallets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wallets);
  }

  @override
  @NumberToStringConverter()
  final String totalBalance;

  @override
  String toString() {
    return 'WalletViewAggregationItem(wallets: $wallets, totalBalance: $totalBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletViewAggregationItemImpl &&
            const DeepCollectionEquality().equals(other._wallets, _wallets) &&
            (identical(other.totalBalance, totalBalance) ||
                other.totalBalance == totalBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_wallets), totalBalance);

  /// Create a copy of WalletViewAggregationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletViewAggregationItemImplCopyWith<_$WalletViewAggregationItemImpl>
      get copyWith => __$$WalletViewAggregationItemImplCopyWithImpl<
          _$WalletViewAggregationItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletViewAggregationItemImplToJson(
      this,
    );
  }
}

abstract class _WalletViewAggregationItem implements WalletViewAggregationItem {
  const factory _WalletViewAggregationItem(
          {@JsonKey(defaultValue: [])
          required final List<WalletViewAggregationWallet> wallets,
          @NumberToStringConverter() required final String totalBalance}) =
      _$WalletViewAggregationItemImpl;

  factory _WalletViewAggregationItem.fromJson(Map<String, dynamic> json) =
      _$WalletViewAggregationItemImpl.fromJson;

  @override
  @JsonKey(defaultValue: [])
  List<WalletViewAggregationWallet> get wallets;
  @override
  @NumberToStringConverter()
  String get totalBalance;

  /// Create a copy of WalletViewAggregationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletViewAggregationItemImplCopyWith<_$WalletViewAggregationItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}
