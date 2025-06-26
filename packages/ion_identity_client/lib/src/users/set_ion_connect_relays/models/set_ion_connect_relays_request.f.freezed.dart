// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_ion_connect_relays_request.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SetIONConnectRelaysRequest _$SetIONConnectRelaysRequestFromJson(
    Map<String, dynamic> json) {
  return _SetIONConnectRelaysRequest.fromJson(json);
}

/// @nodoc
mixin _$SetIONConnectRelaysRequest {
  List<String> get followeeList => throw _privateConstructorUsedError;

  /// Serializes this SetIONConnectRelaysRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetIONConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetIONConnectRelaysRequestCopyWith<SetIONConnectRelaysRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetIONConnectRelaysRequestCopyWith<$Res> {
  factory $SetIONConnectRelaysRequestCopyWith(SetIONConnectRelaysRequest value,
          $Res Function(SetIONConnectRelaysRequest) then) =
      _$SetIONConnectRelaysRequestCopyWithImpl<$Res,
          SetIONConnectRelaysRequest>;
  @useResult
  $Res call({List<String> followeeList});
}

/// @nodoc
class _$SetIONConnectRelaysRequestCopyWithImpl<$Res,
        $Val extends SetIONConnectRelaysRequest>
    implements $SetIONConnectRelaysRequestCopyWith<$Res> {
  _$SetIONConnectRelaysRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetIONConnectRelaysRequest
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
abstract class _$$SetIONConnectRelaysRequestImplCopyWith<$Res>
    implements $SetIONConnectRelaysRequestCopyWith<$Res> {
  factory _$$SetIONConnectRelaysRequestImplCopyWith(
          _$SetIONConnectRelaysRequestImpl value,
          $Res Function(_$SetIONConnectRelaysRequestImpl) then) =
      __$$SetIONConnectRelaysRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> followeeList});
}

/// @nodoc
class __$$SetIONConnectRelaysRequestImplCopyWithImpl<$Res>
    extends _$SetIONConnectRelaysRequestCopyWithImpl<$Res,
        _$SetIONConnectRelaysRequestImpl>
    implements _$$SetIONConnectRelaysRequestImplCopyWith<$Res> {
  __$$SetIONConnectRelaysRequestImplCopyWithImpl(
      _$SetIONConnectRelaysRequestImpl _value,
      $Res Function(_$SetIONConnectRelaysRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetIONConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followeeList = null,
  }) {
    return _then(_$SetIONConnectRelaysRequestImpl(
      followeeList: null == followeeList
          ? _value._followeeList
          : followeeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetIONConnectRelaysRequestImpl implements _SetIONConnectRelaysRequest {
  const _$SetIONConnectRelaysRequestImpl(
      {required final List<String> followeeList})
      : _followeeList = followeeList;

  factory _$SetIONConnectRelaysRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SetIONConnectRelaysRequestImplFromJson(json);

  final List<String> _followeeList;
  @override
  List<String> get followeeList {
    if (_followeeList is EqualUnmodifiableListView) return _followeeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followeeList);
  }

  @override
  String toString() {
    return 'SetIONConnectRelaysRequest(followeeList: $followeeList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetIONConnectRelaysRequestImpl &&
            const DeepCollectionEquality()
                .equals(other._followeeList, _followeeList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_followeeList));

  /// Create a copy of SetIONConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetIONConnectRelaysRequestImplCopyWith<_$SetIONConnectRelaysRequestImpl>
      get copyWith => __$$SetIONConnectRelaysRequestImplCopyWithImpl<
          _$SetIONConnectRelaysRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetIONConnectRelaysRequestImplToJson(
      this,
    );
  }
}

abstract class _SetIONConnectRelaysRequest
    implements SetIONConnectRelaysRequest {
  const factory _SetIONConnectRelaysRequest(
          {required final List<String> followeeList}) =
      _$SetIONConnectRelaysRequestImpl;

  factory _SetIONConnectRelaysRequest.fromJson(Map<String, dynamic> json) =
      _$SetIONConnectRelaysRequestImpl.fromJson;

  @override
  List<String> get followeeList;

  /// Create a copy of SetIONConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetIONConnectRelaysRequestImplCopyWith<_$SetIONConnectRelaysRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
