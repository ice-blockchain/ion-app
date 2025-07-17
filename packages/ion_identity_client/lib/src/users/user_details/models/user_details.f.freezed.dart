// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_details.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) {
  return _UserDetails.fromJson(json);
}

/// @nodoc
mixin _$UserDetails {
  List<String> get ionConnectIndexerRelays =>
      throw _privateConstructorUsedError;
  String get masterPubKey => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(name: '2faOptions')
  List<String>? get twoFaOptions => throw _privateConstructorUsedError;
  List<String>? get email => throw _privateConstructorUsedError;
  List<String>? get phoneNumber => throw _privateConstructorUsedError;
  List<IonConnectRelayInfo>? get ionConnectRelays =>
      throw _privateConstructorUsedError;

  /// Serializes this UserDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDetailsCopyWith<UserDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDetailsCopyWith<$Res> {
  factory $UserDetailsCopyWith(
          UserDetails value, $Res Function(UserDetails) then) =
      _$UserDetailsCopyWithImpl<$Res, UserDetails>;
  @useResult
  $Res call(
      {List<String> ionConnectIndexerRelays,
      String masterPubKey,
      String? name,
      String? userId,
      String? username,
      @JsonKey(name: '2faOptions') List<String>? twoFaOptions,
      List<String>? email,
      List<String>? phoneNumber,
      List<IonConnectRelayInfo>? ionConnectRelays});
}

/// @nodoc
class _$UserDetailsCopyWithImpl<$Res, $Val extends UserDetails>
    implements $UserDetailsCopyWith<$Res> {
  _$UserDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectIndexerRelays = null,
    Object? masterPubKey = null,
    Object? name = freezed,
    Object? userId = freezed,
    Object? username = freezed,
    Object? twoFaOptions = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? ionConnectRelays = freezed,
  }) {
    return _then(_value.copyWith(
      ionConnectIndexerRelays: null == ionConnectIndexerRelays
          ? _value.ionConnectIndexerRelays
          : ionConnectIndexerRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      masterPubKey: null == masterPubKey
          ? _value.masterPubKey
          : masterPubKey // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      twoFaOptions: freezed == twoFaOptions
          ? _value.twoFaOptions
          : twoFaOptions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      ionConnectRelays: freezed == ionConnectRelays
          ? _value.ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<IonConnectRelayInfo>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDetailsImplCopyWith<$Res>
    implements $UserDetailsCopyWith<$Res> {
  factory _$$UserDetailsImplCopyWith(
          _$UserDetailsImpl value, $Res Function(_$UserDetailsImpl) then) =
      __$$UserDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> ionConnectIndexerRelays,
      String masterPubKey,
      String? name,
      String? userId,
      String? username,
      @JsonKey(name: '2faOptions') List<String>? twoFaOptions,
      List<String>? email,
      List<String>? phoneNumber,
      List<IonConnectRelayInfo>? ionConnectRelays});
}

/// @nodoc
class __$$UserDetailsImplCopyWithImpl<$Res>
    extends _$UserDetailsCopyWithImpl<$Res, _$UserDetailsImpl>
    implements _$$UserDetailsImplCopyWith<$Res> {
  __$$UserDetailsImplCopyWithImpl(
      _$UserDetailsImpl _value, $Res Function(_$UserDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ionConnectIndexerRelays = null,
    Object? masterPubKey = null,
    Object? name = freezed,
    Object? userId = freezed,
    Object? username = freezed,
    Object? twoFaOptions = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? ionConnectRelays = freezed,
  }) {
    return _then(_$UserDetailsImpl(
      ionConnectIndexerRelays: null == ionConnectIndexerRelays
          ? _value._ionConnectIndexerRelays
          : ionConnectIndexerRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      masterPubKey: null == masterPubKey
          ? _value.masterPubKey
          : masterPubKey // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      twoFaOptions: freezed == twoFaOptions
          ? _value._twoFaOptions
          : twoFaOptions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      email: freezed == email
          ? _value._email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      phoneNumber: freezed == phoneNumber
          ? _value._phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      ionConnectRelays: freezed == ionConnectRelays
          ? _value._ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<IonConnectRelayInfo>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDetailsImpl implements _UserDetails {
  const _$UserDetailsImpl(
      {required final List<String> ionConnectIndexerRelays,
      required this.masterPubKey,
      this.name,
      this.userId,
      this.username,
      @JsonKey(name: '2faOptions') final List<String>? twoFaOptions,
      final List<String>? email,
      final List<String>? phoneNumber,
      final List<IonConnectRelayInfo>? ionConnectRelays})
      : _ionConnectIndexerRelays = ionConnectIndexerRelays,
        _twoFaOptions = twoFaOptions,
        _email = email,
        _phoneNumber = phoneNumber,
        _ionConnectRelays = ionConnectRelays;

  factory _$UserDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDetailsImplFromJson(json);

  final List<String> _ionConnectIndexerRelays;
  @override
  List<String> get ionConnectIndexerRelays {
    if (_ionConnectIndexerRelays is EqualUnmodifiableListView)
      return _ionConnectIndexerRelays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ionConnectIndexerRelays);
  }

  @override
  final String masterPubKey;
  @override
  final String? name;
  @override
  final String? userId;
  @override
  final String? username;
  final List<String>? _twoFaOptions;
  @override
  @JsonKey(name: '2faOptions')
  List<String>? get twoFaOptions {
    final value = _twoFaOptions;
    if (value == null) return null;
    if (_twoFaOptions is EqualUnmodifiableListView) return _twoFaOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _email;
  @override
  List<String>? get email {
    final value = _email;
    if (value == null) return null;
    if (_email is EqualUnmodifiableListView) return _email;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _phoneNumber;
  @override
  List<String>? get phoneNumber {
    final value = _phoneNumber;
    if (value == null) return null;
    if (_phoneNumber is EqualUnmodifiableListView) return _phoneNumber;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<IonConnectRelayInfo>? _ionConnectRelays;
  @override
  List<IonConnectRelayInfo>? get ionConnectRelays {
    final value = _ionConnectRelays;
    if (value == null) return null;
    if (_ionConnectRelays is EqualUnmodifiableListView)
      return _ionConnectRelays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserDetails(ionConnectIndexerRelays: $ionConnectIndexerRelays, masterPubKey: $masterPubKey, name: $name, userId: $userId, username: $username, twoFaOptions: $twoFaOptions, email: $email, phoneNumber: $phoneNumber, ionConnectRelays: $ionConnectRelays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDetailsImpl &&
            const DeepCollectionEquality().equals(
                other._ionConnectIndexerRelays, _ionConnectIndexerRelays) &&
            (identical(other.masterPubKey, masterPubKey) ||
                other.masterPubKey == masterPubKey) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            const DeepCollectionEquality()
                .equals(other._twoFaOptions, _twoFaOptions) &&
            const DeepCollectionEquality().equals(other._email, _email) &&
            const DeepCollectionEquality()
                .equals(other._phoneNumber, _phoneNumber) &&
            const DeepCollectionEquality()
                .equals(other._ionConnectRelays, _ionConnectRelays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_ionConnectIndexerRelays),
      masterPubKey,
      name,
      userId,
      username,
      const DeepCollectionEquality().hash(_twoFaOptions),
      const DeepCollectionEquality().hash(_email),
      const DeepCollectionEquality().hash(_phoneNumber),
      const DeepCollectionEquality().hash(_ionConnectRelays));

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDetailsImplCopyWith<_$UserDetailsImpl> get copyWith =>
      __$$UserDetailsImplCopyWithImpl<_$UserDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDetailsImplToJson(
      this,
    );
  }
}

abstract class _UserDetails implements UserDetails {
  const factory _UserDetails(
      {required final List<String> ionConnectIndexerRelays,
      required final String masterPubKey,
      final String? name,
      final String? userId,
      final String? username,
      @JsonKey(name: '2faOptions') final List<String>? twoFaOptions,
      final List<String>? email,
      final List<String>? phoneNumber,
      final List<IonConnectRelayInfo>? ionConnectRelays}) = _$UserDetailsImpl;

  factory _UserDetails.fromJson(Map<String, dynamic> json) =
      _$UserDetailsImpl.fromJson;

  @override
  List<String> get ionConnectIndexerRelays;
  @override
  String get masterPubKey;
  @override
  String? get name;
  @override
  String? get userId;
  @override
  String? get username;
  @override
  @JsonKey(name: '2faOptions')
  List<String>? get twoFaOptions;
  @override
  List<String>? get email;
  @override
  List<String>? get phoneNumber;
  @override
  List<IonConnectRelayInfo>? get ionConnectRelays;

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDetailsImplCopyWith<_$UserDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
