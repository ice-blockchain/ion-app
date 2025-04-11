// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Network _$NetworkFromJson(Map<String, dynamic> json) {
  return _Network.fromJson(json);
}

/// @nodoc
mixin _$Network {
  String get displayName => throw _privateConstructorUsedError;
  String get explorerUrl => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  bool get isTestnet => throw _privateConstructorUsedError;
  int get tier => throw _privateConstructorUsedError;

  /// Serializes this Network to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Network
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetworkCopyWith<Network> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkCopyWith<$Res> {
  factory $NetworkCopyWith(Network value, $Res Function(Network) then) =
      _$NetworkCopyWithImpl<$Res, Network>;
  @useResult
  $Res call(
      {String displayName,
      String explorerUrl,
      String id,
      String image,
      bool isTestnet,
      int tier});
}

/// @nodoc
class _$NetworkCopyWithImpl<$Res, $Val extends Network>
    implements $NetworkCopyWith<$Res> {
  _$NetworkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Network
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? explorerUrl = null,
    Object? id = null,
    Object? image = null,
    Object? isTestnet = null,
    Object? tier = null,
  }) {
    return _then(_value.copyWith(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      explorerUrl: null == explorerUrl
          ? _value.explorerUrl
          : explorerUrl // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      isTestnet: null == isTestnet
          ? _value.isTestnet
          : isTestnet // ignore: cast_nullable_to_non_nullable
              as bool,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkImplCopyWith<$Res> implements $NetworkCopyWith<$Res> {
  factory _$$NetworkImplCopyWith(
          _$NetworkImpl value, $Res Function(_$NetworkImpl) then) =
      __$$NetworkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String displayName,
      String explorerUrl,
      String id,
      String image,
      bool isTestnet,
      int tier});
}

/// @nodoc
class __$$NetworkImplCopyWithImpl<$Res>
    extends _$NetworkCopyWithImpl<$Res, _$NetworkImpl>
    implements _$$NetworkImplCopyWith<$Res> {
  __$$NetworkImplCopyWithImpl(
      _$NetworkImpl _value, $Res Function(_$NetworkImpl) _then)
      : super(_value, _then);

  /// Create a copy of Network
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? explorerUrl = null,
    Object? id = null,
    Object? image = null,
    Object? isTestnet = null,
    Object? tier = null,
  }) {
    return _then(_$NetworkImpl(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      explorerUrl: null == explorerUrl
          ? _value.explorerUrl
          : explorerUrl // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      isTestnet: null == isTestnet
          ? _value.isTestnet
          : isTestnet // ignore: cast_nullable_to_non_nullable
              as bool,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkImpl implements _Network {
  const _$NetworkImpl(
      {required this.displayName,
      required this.explorerUrl,
      required this.id,
      required this.image,
      required this.isTestnet,
      required this.tier});

  factory _$NetworkImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkImplFromJson(json);

  @override
  final String displayName;
  @override
  final String explorerUrl;
  @override
  final String id;
  @override
  final String image;
  @override
  final bool isTestnet;
  @override
  final int tier;

  @override
  String toString() {
    return 'Network(displayName: $displayName, explorerUrl: $explorerUrl, id: $id, image: $image, isTestnet: $isTestnet, tier: $tier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkImpl &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.explorerUrl, explorerUrl) ||
                other.explorerUrl == explorerUrl) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.isTestnet, isTestnet) ||
                other.isTestnet == isTestnet) &&
            (identical(other.tier, tier) || other.tier == tier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, displayName, explorerUrl, id, image, isTestnet, tier);

  /// Create a copy of Network
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkImplCopyWith<_$NetworkImpl> get copyWith =>
      __$$NetworkImplCopyWithImpl<_$NetworkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkImplToJson(
      this,
    );
  }
}

abstract class _Network implements Network {
  const factory _Network(
      {required final String displayName,
      required final String explorerUrl,
      required final String id,
      required final String image,
      required final bool isTestnet,
      required final int tier}) = _$NetworkImpl;

  factory _Network.fromJson(Map<String, dynamic> json) = _$NetworkImpl.fromJson;

  @override
  String get displayName;
  @override
  String get explorerUrl;
  @override
  String get id;
  @override
  String get image;
  @override
  bool get isTestnet;
  @override
  int get tier;

  /// Create a copy of Network
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkImplCopyWith<_$NetworkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
