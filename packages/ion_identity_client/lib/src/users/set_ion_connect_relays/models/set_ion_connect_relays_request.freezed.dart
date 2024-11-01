// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_ion_connect_relays_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SetIonConnectRelaysRequest _$SetIonConnectRelaysRequestFromJson(
    Map<String, dynamic> json) {
  return _SetIonConnectRelaysRequest.fromJson(json);
}

/// @nodoc
mixin _$SetIonConnectRelaysRequest {
  List<String> get followeeList => throw _privateConstructorUsedError;

  /// Serializes this SetIonConnectRelaysRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetIonConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetIonConnectRelaysRequestCopyWith<SetIonConnectRelaysRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetIonConnectRelaysRequestCopyWith<$Res> {
  factory $SetIonConnectRelaysRequestCopyWith(SetIonConnectRelaysRequest value,
          $Res Function(SetIonConnectRelaysRequest) then) =
      _$SetIonConnectRelaysRequestCopyWithImpl<$Res,
          SetIonConnectRelaysRequest>;
  @useResult
  $Res call({List<String> followeeList});
}

/// @nodoc
class _$SetIonConnectRelaysRequestCopyWithImpl<$Res,
        $Val extends SetIonConnectRelaysRequest>
    implements $SetIonConnectRelaysRequestCopyWith<$Res> {
  _$SetIonConnectRelaysRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetIonConnectRelaysRequest
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
abstract class _$$SetIonConnectRelaysRequestImplCopyWith<$Res>
    implements $SetIonConnectRelaysRequestCopyWith<$Res> {
  factory _$$SetIonConnectRelaysRequestImplCopyWith(
          _$SetIonConnectRelaysRequestImpl value,
          $Res Function(_$SetIonConnectRelaysRequestImpl) then) =
      __$$SetIonConnectRelaysRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> followeeList});
}

/// @nodoc
class __$$SetIonConnectRelaysRequestImplCopyWithImpl<$Res>
    extends _$SetIonConnectRelaysRequestCopyWithImpl<$Res,
        _$SetIonConnectRelaysRequestImpl>
    implements _$$SetIonConnectRelaysRequestImplCopyWith<$Res> {
  __$$SetIonConnectRelaysRequestImplCopyWithImpl(
      _$SetIonConnectRelaysRequestImpl _value,
      $Res Function(_$SetIonConnectRelaysRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetIonConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followeeList = null,
  }) {
    return _then(_$SetIonConnectRelaysRequestImpl(
      followeeList: null == followeeList
          ? _value._followeeList
          : followeeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetIonConnectRelaysRequestImpl implements _SetIonConnectRelaysRequest {
  const _$SetIonConnectRelaysRequestImpl(
      {required final List<String> followeeList})
      : _followeeList = followeeList;

  factory _$SetIonConnectRelaysRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SetIonConnectRelaysRequestImplFromJson(json);

  final List<String> _followeeList;
  @override
  List<String> get followeeList {
    if (_followeeList is EqualUnmodifiableListView) return _followeeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_followeeList);
  }

  @override
  String toString() {
    return 'SetIonConnectRelaysRequest(followeeList: $followeeList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetIonConnectRelaysRequestImpl &&
            const DeepCollectionEquality()
                .equals(other._followeeList, _followeeList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_followeeList));

  /// Create a copy of SetIonConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetIonConnectRelaysRequestImplCopyWith<_$SetIonConnectRelaysRequestImpl>
      get copyWith => __$$SetIonConnectRelaysRequestImplCopyWithImpl<
          _$SetIonConnectRelaysRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetIonConnectRelaysRequestImplToJson(
      this,
    );
  }
}

abstract class _SetIonConnectRelaysRequest
    implements SetIonConnectRelaysRequest {
  const factory _SetIonConnectRelaysRequest(
          {required final List<String> followeeList}) =
      _$SetIonConnectRelaysRequestImpl;

  factory _SetIonConnectRelaysRequest.fromJson(Map<String, dynamic> json) =
      _$SetIonConnectRelaysRequestImpl.fromJson;

  @override
  List<String> get followeeList;

  /// Create a copy of SetIonConnectRelaysRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetIonConnectRelaysRequestImplCopyWith<_$SetIonConnectRelaysRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
