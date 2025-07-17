// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ion_connect_relay_info.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IonConnectRelayInfo _$IonConnectRelayInfoFromJson(Map<String, dynamic> json) {
  return _IonConnectRelayInfo.fromJson(json);
}

/// @nodoc
mixin _$IonConnectRelayInfo {
  String get url => throw _privateConstructorUsedError;
  IonConnectRelayType? get type => throw _privateConstructorUsedError;

  /// Serializes this IonConnectRelayInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IonConnectRelayInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IonConnectRelayInfoCopyWith<IonConnectRelayInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IonConnectRelayInfoCopyWith<$Res> {
  factory $IonConnectRelayInfoCopyWith(
          IonConnectRelayInfo value, $Res Function(IonConnectRelayInfo) then) =
      _$IonConnectRelayInfoCopyWithImpl<$Res, IonConnectRelayInfo>;
  @useResult
  $Res call({String url, IonConnectRelayType? type});
}

/// @nodoc
class _$IonConnectRelayInfoCopyWithImpl<$Res, $Val extends IonConnectRelayInfo>
    implements $IonConnectRelayInfoCopyWith<$Res> {
  _$IonConnectRelayInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IonConnectRelayInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as IonConnectRelayType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IonConnectRelayInfoImplCopyWith<$Res>
    implements $IonConnectRelayInfoCopyWith<$Res> {
  factory _$$IonConnectRelayInfoImplCopyWith(_$IonConnectRelayInfoImpl value,
          $Res Function(_$IonConnectRelayInfoImpl) then) =
      __$$IonConnectRelayInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, IonConnectRelayType? type});
}

/// @nodoc
class __$$IonConnectRelayInfoImplCopyWithImpl<$Res>
    extends _$IonConnectRelayInfoCopyWithImpl<$Res, _$IonConnectRelayInfoImpl>
    implements _$$IonConnectRelayInfoImplCopyWith<$Res> {
  __$$IonConnectRelayInfoImplCopyWithImpl(_$IonConnectRelayInfoImpl _value,
      $Res Function(_$IonConnectRelayInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of IonConnectRelayInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? type = freezed,
  }) {
    return _then(_$IonConnectRelayInfoImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as IonConnectRelayType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IonConnectRelayInfoImpl implements _IonConnectRelayInfo {
  const _$IonConnectRelayInfoImpl({required this.url, this.type});

  factory _$IonConnectRelayInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$IonConnectRelayInfoImplFromJson(json);

  @override
  final String url;
  @override
  final IonConnectRelayType? type;

  @override
  String toString() {
    return 'IonConnectRelayInfo(url: $url, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IonConnectRelayInfoImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, type);

  /// Create a copy of IonConnectRelayInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IonConnectRelayInfoImplCopyWith<_$IonConnectRelayInfoImpl> get copyWith =>
      __$$IonConnectRelayInfoImplCopyWithImpl<_$IonConnectRelayInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IonConnectRelayInfoImplToJson(
      this,
    );
  }
}

abstract class _IonConnectRelayInfo implements IonConnectRelayInfo {
  const factory _IonConnectRelayInfo(
      {required final String url,
      final IonConnectRelayType? type}) = _$IonConnectRelayInfoImpl;

  factory _IonConnectRelayInfo.fromJson(Map<String, dynamic> json) =
      _$IonConnectRelayInfoImpl.fromJson;

  @override
  String get url;
  @override
  IonConnectRelayType? get type;

  /// Create a copy of IonConnectRelayInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IonConnectRelayInfoImplCopyWith<_$IonConnectRelayInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
