// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coins_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CoinsResponse _$CoinsResponseFromJson(Map<String, dynamic> json) {
  return _CoinsResponse.fromJson(json);
}

/// @nodoc
mixin _$CoinsResponse {
  List<Coin> get coins => throw _privateConstructorUsedError;
  List<Network> get networks => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this CoinsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoinsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoinsResponseCopyWith<CoinsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoinsResponseCopyWith<$Res> {
  factory $CoinsResponseCopyWith(
          CoinsResponse value, $Res Function(CoinsResponse) then) =
      _$CoinsResponseCopyWithImpl<$Res, CoinsResponse>;
  @useResult
  $Res call({List<Coin> coins, List<Network> networks, int version});
}

/// @nodoc
class _$CoinsResponseCopyWithImpl<$Res, $Val extends CoinsResponse>
    implements $CoinsResponseCopyWith<$Res> {
  _$CoinsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoinsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coins = null,
    Object? networks = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      coins: null == coins
          ? _value.coins
          : coins // ignore: cast_nullable_to_non_nullable
              as List<Coin>,
      networks: null == networks
          ? _value.networks
          : networks // ignore: cast_nullable_to_non_nullable
              as List<Network>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoinsResponseImplCopyWith<$Res>
    implements $CoinsResponseCopyWith<$Res> {
  factory _$$CoinsResponseImplCopyWith(
          _$CoinsResponseImpl value, $Res Function(_$CoinsResponseImpl) then) =
      __$$CoinsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Coin> coins, List<Network> networks, int version});
}

/// @nodoc
class __$$CoinsResponseImplCopyWithImpl<$Res>
    extends _$CoinsResponseCopyWithImpl<$Res, _$CoinsResponseImpl>
    implements _$$CoinsResponseImplCopyWith<$Res> {
  __$$CoinsResponseImplCopyWithImpl(
      _$CoinsResponseImpl _value, $Res Function(_$CoinsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CoinsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coins = null,
    Object? networks = null,
    Object? version = null,
  }) {
    return _then(_$CoinsResponseImpl(
      coins: null == coins
          ? _value._coins
          : coins // ignore: cast_nullable_to_non_nullable
              as List<Coin>,
      networks: null == networks
          ? _value._networks
          : networks // ignore: cast_nullable_to_non_nullable
              as List<Network>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoinsResponseImpl implements _CoinsResponse {
  const _$CoinsResponseImpl(
      {required final List<Coin> coins,
      required final List<Network> networks,
      required this.version})
      : _coins = coins,
        _networks = networks;

  factory _$CoinsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoinsResponseImplFromJson(json);

  final List<Coin> _coins;
  @override
  List<Coin> get coins {
    if (_coins is EqualUnmodifiableListView) return _coins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coins);
  }

  final List<Network> _networks;
  @override
  List<Network> get networks {
    if (_networks is EqualUnmodifiableListView) return _networks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_networks);
  }

  @override
  final int version;

  @override
  String toString() {
    return 'CoinsResponse(coins: $coins, networks: $networks, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoinsResponseImpl &&
            const DeepCollectionEquality().equals(other._coins, _coins) &&
            const DeepCollectionEquality().equals(other._networks, _networks) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_coins),
      const DeepCollectionEquality().hash(_networks),
      version);

  /// Create a copy of CoinsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoinsResponseImplCopyWith<_$CoinsResponseImpl> get copyWith =>
      __$$CoinsResponseImplCopyWithImpl<_$CoinsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoinsResponseImplToJson(
      this,
    );
  }
}

abstract class _CoinsResponse implements CoinsResponse {
  const factory _CoinsResponse(
      {required final List<Coin> coins,
      required final List<Network> networks,
      required final int version}) = _$CoinsResponseImpl;

  factory _CoinsResponse.fromJson(Map<String, dynamic> json) =
      _$CoinsResponseImpl.fromJson;

  @override
  List<Coin> get coins;
  @override
  List<Network> get networks;
  @override
  int get version;

  /// Create a copy of CoinsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoinsResponseImplCopyWith<_$CoinsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
