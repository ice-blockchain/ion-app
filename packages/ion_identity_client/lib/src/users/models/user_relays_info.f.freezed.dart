// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_relays_info.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserRelaysInfo _$UserRelaysInfoFromJson(Map<String, dynamic> json) {
  return _UserRelaysInfo.fromJson(json);
}

/// @nodoc
mixin _$UserRelaysInfo {
  String get masterPubKey => throw _privateConstructorUsedError;
  List<String> get ionConnectRelays => throw _privateConstructorUsedError;

  /// Serializes this UserRelaysInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRelaysInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRelaysInfoCopyWith<UserRelaysInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRelaysInfoCopyWith<$Res> {
  factory $UserRelaysInfoCopyWith(
          UserRelaysInfo value, $Res Function(UserRelaysInfo) then) =
      _$UserRelaysInfoCopyWithImpl<$Res, UserRelaysInfo>;
  @useResult
  $Res call({String masterPubKey, List<String> ionConnectRelays});
}

/// @nodoc
class _$UserRelaysInfoCopyWithImpl<$Res, $Val extends UserRelaysInfo>
    implements $UserRelaysInfoCopyWith<$Res> {
  _$UserRelaysInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRelaysInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterPubKey = null,
    Object? ionConnectRelays = null,
  }) {
    return _then(_value.copyWith(
      masterPubKey: null == masterPubKey
          ? _value.masterPubKey
          : masterPubKey // ignore: cast_nullable_to_non_nullable
              as String,
      ionConnectRelays: null == ionConnectRelays
          ? _value.ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRelaysInfoImplCopyWith<$Res>
    implements $UserRelaysInfoCopyWith<$Res> {
  factory _$$UserRelaysInfoImplCopyWith(_$UserRelaysInfoImpl value,
          $Res Function(_$UserRelaysInfoImpl) then) =
      __$$UserRelaysInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String masterPubKey, List<String> ionConnectRelays});
}

/// @nodoc
class __$$UserRelaysInfoImplCopyWithImpl<$Res>
    extends _$UserRelaysInfoCopyWithImpl<$Res, _$UserRelaysInfoImpl>
    implements _$$UserRelaysInfoImplCopyWith<$Res> {
  __$$UserRelaysInfoImplCopyWithImpl(
      _$UserRelaysInfoImpl _value, $Res Function(_$UserRelaysInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserRelaysInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterPubKey = null,
    Object? ionConnectRelays = null,
  }) {
    return _then(_$UserRelaysInfoImpl(
      masterPubKey: null == masterPubKey
          ? _value.masterPubKey
          : masterPubKey // ignore: cast_nullable_to_non_nullable
              as String,
      ionConnectRelays: null == ionConnectRelays
          ? _value._ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRelaysInfoImpl implements _UserRelaysInfo {
  const _$UserRelaysInfoImpl(
      {required this.masterPubKey,
      required final List<String> ionConnectRelays})
      : _ionConnectRelays = ionConnectRelays;

  factory _$UserRelaysInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRelaysInfoImplFromJson(json);

  @override
  final String masterPubKey;
  final List<String> _ionConnectRelays;
  @override
  List<String> get ionConnectRelays {
    if (_ionConnectRelays is EqualUnmodifiableListView)
      return _ionConnectRelays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ionConnectRelays);
  }

  @override
  String toString() {
    return 'UserRelaysInfo(masterPubKey: $masterPubKey, ionConnectRelays: $ionConnectRelays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRelaysInfoImpl &&
            (identical(other.masterPubKey, masterPubKey) ||
                other.masterPubKey == masterPubKey) &&
            const DeepCollectionEquality()
                .equals(other._ionConnectRelays, _ionConnectRelays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, masterPubKey,
      const DeepCollectionEquality().hash(_ionConnectRelays));

  /// Create a copy of UserRelaysInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRelaysInfoImplCopyWith<_$UserRelaysInfoImpl> get copyWith =>
      __$$UserRelaysInfoImplCopyWithImpl<_$UserRelaysInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRelaysInfoImplToJson(
      this,
    );
  }
}

abstract class _UserRelaysInfo implements UserRelaysInfo {
  const factory _UserRelaysInfo(
      {required final String masterPubKey,
      required final List<String> ionConnectRelays}) = _$UserRelaysInfoImpl;

  factory _UserRelaysInfo.fromJson(Map<String, dynamic> json) =
      _$UserRelaysInfoImpl.fromJson;

  @override
  String get masterPubKey;
  @override
  List<String> get ionConnectRelays;

  /// Create a copy of UserRelaysInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRelaysInfoImplCopyWith<_$UserRelaysInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
