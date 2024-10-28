// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_user_connect_relays_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SetUserConnectRelaysRequest _$SetUserConnectRelaysRequestFromJson(
    Map<String, dynamic> json) {
  return _SetUserConnectRelaysRequest.fromJson(json);
}

/// @nodoc
mixin _$SetUserConnectRelaysRequest {
  List<String> get followeeList => throw _privateConstructorUsedError;

  /// Serializes this SetUserConnectRelaysRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetUserConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetUserConnectRelaysRequestCopyWith<SetUserConnectRelaysRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetUserConnectRelaysRequestCopyWith<$Res> {
  factory $SetUserConnectRelaysRequestCopyWith(
          SetUserConnectRelaysRequest value,
          $Res Function(SetUserConnectRelaysRequest) then) =
      _$SetUserConnectRelaysRequestCopyWithImpl<$Res,
          SetUserConnectRelaysRequest>;
  @useResult
  $Res call({List<String> followeeList});
}

/// @nodoc
class _$SetUserConnectRelaysRequestCopyWithImpl<$Res,
        $Val extends SetUserConnectRelaysRequest>
    implements $SetUserConnectRelaysRequestCopyWith<$Res> {
  _$SetUserConnectRelaysRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetUserConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followeeList = null,
  }) {
    return _then(_value.copyWith(
      followeeList: null == followeeList
          ? _value.followeeList
          : followeeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetUserConnectRelaysRequestImplCopyWith<$Res>
    implements $SetUserConnectRelaysRequestCopyWith<$Res> {
  factory _$$SetUserConnectRelaysRequestImplCopyWith(
          _$SetUserConnectRelaysRequestImpl value,
          $Res Function(_$SetUserConnectRelaysRequestImpl) then) =
      __$$SetUserConnectRelaysRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> followeeList});
}

/// @nodoc
class __$$SetUserConnectRelaysRequestImplCopyWithImpl<$Res>
    extends _$SetUserConnectRelaysRequestCopyWithImpl<$Res,
        _$SetUserConnectRelaysRequestImpl>
    implements _$$SetUserConnectRelaysRequestImplCopyWith<$Res> {
  __$$SetUserConnectRelaysRequestImplCopyWithImpl(
      _$SetUserConnectRelaysRequestImpl _value,
      $Res Function(_$SetUserConnectRelaysRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetUserConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followeeList = null,
  }) {
    return _then(_$SetUserConnectRelaysRequestImpl(
      followeeList: null == followeeList
          ? _value._followeeList
          : followeeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetUserConnectRelaysRequestImpl
    implements _SetUserConnectRelaysRequest {
  const _$SetUserConnectRelaysRequestImpl(
      {required final List<String> followeeList})
      : _followeeList = followeeList;

  factory _$SetUserConnectRelaysRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SetUserConnectRelaysRequestImplFromJson(json);

  final List<String> _followeeList;
  @override
  List<String> get followeeList {
    if (_followeeList is EqualUnmodifiableListView) return _followeeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followeeList);
  }

  @override
  String toString() {
    return 'SetUserConnectRelaysRequest(followeeList: $followeeList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetUserConnectRelaysRequestImpl &&
            const DeepCollectionEquality()
                .equals(other._followeeList, _followeeList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_followeeList));

  /// Create a copy of SetUserConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetUserConnectRelaysRequestImplCopyWith<_$SetUserConnectRelaysRequestImpl>
      get copyWith => __$$SetUserConnectRelaysRequestImplCopyWithImpl<
          _$SetUserConnectRelaysRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetUserConnectRelaysRequestImplToJson(
      this,
    );
  }
}

abstract class _SetUserConnectRelaysRequest
    implements SetUserConnectRelaysRequest {
  const factory _SetUserConnectRelaysRequest(
          {required final List<String> followeeList}) =
      _$SetUserConnectRelaysRequestImpl;

  factory _SetUserConnectRelaysRequest.fromJson(Map<String, dynamic> json) =
      _$SetUserConnectRelaysRequestImpl.fromJson;

  @override
  List<String> get followeeList;

  /// Create a copy of SetUserConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetUserConnectRelaysRequestImplCopyWith<_$SetUserConnectRelaysRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
