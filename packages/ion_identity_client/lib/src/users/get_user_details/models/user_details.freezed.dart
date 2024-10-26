// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_details.dart';

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
  @JsonKey(name: '2faOptions')
  List<String> get twoFaOptions => throw _privateConstructorUsedError;
  String get credentialUuid => throw _privateConstructorUsedError;
  List<String> get ionConnectIndexerRelays =>
      throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isRegistered => throw _privateConstructorUsedError;
  bool get isServiceAccount => throw _privateConstructorUsedError;
  String get kind => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  List<String>? get email => throw _privateConstructorUsedError;
  List<String>? get ionConnectRelays => throw _privateConstructorUsedError;
  List<String>? get phoneNumber => throw _privateConstructorUsedError;

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
      {@JsonKey(name: '2faOptions') List<String> twoFaOptions,
      String credentialUuid,
      List<String> ionConnectIndexerRelays,
      bool isActive,
      bool isRegistered,
      bool isServiceAccount,
      String kind,
      String name,
      String orgId,
      List<String> permissions,
      String userId,
      String username,
      List<String>? email,
      List<String>? ionConnectRelays,
      List<String>? phoneNumber});
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
    Object? twoFaOptions = null,
    Object? credentialUuid = null,
    Object? ionConnectIndexerRelays = null,
    Object? isActive = null,
    Object? isRegistered = null,
    Object? isServiceAccount = null,
    Object? kind = null,
    Object? name = null,
    Object? orgId = null,
    Object? permissions = null,
    Object? userId = null,
    Object? username = null,
    Object? email = freezed,
    Object? ionConnectRelays = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(_value.copyWith(
      twoFaOptions: null == twoFaOptions
          ? _value.twoFaOptions
          : twoFaOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      credentialUuid: null == credentialUuid
          ? _value.credentialUuid
          : credentialUuid // ignore: cast_nullable_to_non_nullable
              as String,
      ionConnectIndexerRelays: null == ionConnectIndexerRelays
          ? _value.ionConnectIndexerRelays
          : ionConnectIndexerRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isRegistered: null == isRegistered
          ? _value.isRegistered
          : isRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      isServiceAccount: null == isServiceAccount
          ? _value.isServiceAccount
          : isServiceAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      ionConnectRelays: freezed == ionConnectRelays
          ? _value.ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      {@JsonKey(name: '2faOptions') List<String> twoFaOptions,
      String credentialUuid,
      List<String> ionConnectIndexerRelays,
      bool isActive,
      bool isRegistered,
      bool isServiceAccount,
      String kind,
      String name,
      String orgId,
      List<String> permissions,
      String userId,
      String username,
      List<String>? email,
      List<String>? ionConnectRelays,
      List<String>? phoneNumber});
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
    Object? twoFaOptions = null,
    Object? credentialUuid = null,
    Object? ionConnectIndexerRelays = null,
    Object? isActive = null,
    Object? isRegistered = null,
    Object? isServiceAccount = null,
    Object? kind = null,
    Object? name = null,
    Object? orgId = null,
    Object? permissions = null,
    Object? userId = null,
    Object? username = null,
    Object? email = freezed,
    Object? ionConnectRelays = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(_$UserDetailsImpl(
      twoFaOptions: null == twoFaOptions
          ? _value._twoFaOptions
          : twoFaOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      credentialUuid: null == credentialUuid
          ? _value.credentialUuid
          : credentialUuid // ignore: cast_nullable_to_non_nullable
              as String,
      ionConnectIndexerRelays: null == ionConnectIndexerRelays
          ? _value._ionConnectIndexerRelays
          : ionConnectIndexerRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isRegistered: null == isRegistered
          ? _value.isRegistered
          : isRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      isServiceAccount: null == isServiceAccount
          ? _value.isServiceAccount
          : isServiceAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value._email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      ionConnectRelays: freezed == ionConnectRelays
          ? _value._ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      phoneNumber: freezed == phoneNumber
          ? _value._phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDetailsImpl implements _UserDetails {
  const _$UserDetailsImpl(
      {@JsonKey(name: '2faOptions') required final List<String> twoFaOptions,
      required this.credentialUuid,
      required final List<String> ionConnectIndexerRelays,
      required this.isActive,
      required this.isRegistered,
      required this.isServiceAccount,
      required this.kind,
      required this.name,
      required this.orgId,
      required final List<String> permissions,
      required this.userId,
      required this.username,
      final List<String>? email,
      final List<String>? ionConnectRelays,
      final List<String>? phoneNumber})
      : _twoFaOptions = twoFaOptions,
        _ionConnectIndexerRelays = ionConnectIndexerRelays,
        _permissions = permissions,
        _email = email,
        _ionConnectRelays = ionConnectRelays,
        _phoneNumber = phoneNumber;

  factory _$UserDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDetailsImplFromJson(json);

  final List<String> _twoFaOptions;
  @override
  @JsonKey(name: '2faOptions')
  List<String> get twoFaOptions {
    if (_twoFaOptions is EqualUnmodifiableListView) return _twoFaOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_twoFaOptions);
  }

  @override
  final String credentialUuid;
  final List<String> _ionConnectIndexerRelays;
  @override
  List<String> get ionConnectIndexerRelays {
    if (_ionConnectIndexerRelays is EqualUnmodifiableListView)
      return _ionConnectIndexerRelays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ionConnectIndexerRelays);
  }

  @override
  final bool isActive;
  @override
  final bool isRegistered;
  @override
  final bool isServiceAccount;
  @override
  final String kind;
  @override
  final String name;
  @override
  final String orgId;
  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final String userId;
  @override
  final String username;
  final List<String>? _email;
  @override
  List<String>? get email {
    final value = _email;
    if (value == null) return null;
    if (_email is EqualUnmodifiableListView) return _email;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _ionConnectRelays;
  @override
  List<String>? get ionConnectRelays {
    final value = _ionConnectRelays;
    if (value == null) return null;
    if (_ionConnectRelays is EqualUnmodifiableListView)
      return _ionConnectRelays;
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

  @override
  String toString() {
    return 'UserDetails(twoFaOptions: $twoFaOptions, credentialUuid: $credentialUuid, ionConnectIndexerRelays: $ionConnectIndexerRelays, isActive: $isActive, isRegistered: $isRegistered, isServiceAccount: $isServiceAccount, kind: $kind, name: $name, orgId: $orgId, permissions: $permissions, userId: $userId, username: $username, email: $email, ionConnectRelays: $ionConnectRelays, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDetailsImpl &&
            const DeepCollectionEquality()
                .equals(other._twoFaOptions, _twoFaOptions) &&
            (identical(other.credentialUuid, credentialUuid) ||
                other.credentialUuid == credentialUuid) &&
            const DeepCollectionEquality().equals(
                other._ionConnectIndexerRelays, _ionConnectIndexerRelays) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isRegistered, isRegistered) ||
                other.isRegistered == isRegistered) &&
            (identical(other.isServiceAccount, isServiceAccount) ||
                other.isServiceAccount == isServiceAccount) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            const DeepCollectionEquality().equals(other._email, _email) &&
            const DeepCollectionEquality()
                .equals(other._ionConnectRelays, _ionConnectRelays) &&
            const DeepCollectionEquality()
                .equals(other._phoneNumber, _phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_twoFaOptions),
      credentialUuid,
      const DeepCollectionEquality().hash(_ionConnectIndexerRelays),
      isActive,
      isRegistered,
      isServiceAccount,
      kind,
      name,
      orgId,
      const DeepCollectionEquality().hash(_permissions),
      userId,
      username,
      const DeepCollectionEquality().hash(_email),
      const DeepCollectionEquality().hash(_ionConnectRelays),
      const DeepCollectionEquality().hash(_phoneNumber));

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
      {@JsonKey(name: '2faOptions') required final List<String> twoFaOptions,
      required final String credentialUuid,
      required final List<String> ionConnectIndexerRelays,
      required final bool isActive,
      required final bool isRegistered,
      required final bool isServiceAccount,
      required final String kind,
      required final String name,
      required final String orgId,
      required final List<String> permissions,
      required final String userId,
      required final String username,
      final List<String>? email,
      final List<String>? ionConnectRelays,
      final List<String>? phoneNumber}) = _$UserDetailsImpl;

  factory _UserDetails.fromJson(Map<String, dynamic> json) =
      _$UserDetailsImpl.fromJson;

  @override
  @JsonKey(name: '2faOptions')
  List<String> get twoFaOptions;
  @override
  String get credentialUuid;
  @override
  List<String> get ionConnectIndexerRelays;
  @override
  bool get isActive;
  @override
  bool get isRegistered;
  @override
  bool get isServiceAccount;
  @override
  String get kind;
  @override
  String get name;
  @override
  String get orgId;
  @override
  List<String> get permissions;
  @override
  String get userId;
  @override
  String get username;
  @override
  List<String>? get email;
  @override
  List<String>? get ionConnectRelays;
  @override
  List<String>? get phoneNumber;

  /// Create a copy of UserDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDetailsImplCopyWith<_$UserDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
