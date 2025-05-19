// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_content_creators_request.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetContentCreatorsRequest _$GetContentCreatorsRequestFromJson(
    Map<String, dynamic> json) {
  return _GetContentCreatorsRequest.fromJson(json);
}

/// @nodoc
mixin _$GetContentCreatorsRequest {
  List<String> get excludeMasterPubKeys => throw _privateConstructorUsedError;

  /// Serializes this GetContentCreatorsRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetContentCreatorsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetContentCreatorsRequestCopyWith<GetContentCreatorsRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetContentCreatorsRequestCopyWith<$Res> {
  factory $GetContentCreatorsRequestCopyWith(GetContentCreatorsRequest value,
          $Res Function(GetContentCreatorsRequest) then) =
      _$GetContentCreatorsRequestCopyWithImpl<$Res, GetContentCreatorsRequest>;
  @useResult
  $Res call({List<String> excludeMasterPubKeys});
}

/// @nodoc
class _$GetContentCreatorsRequestCopyWithImpl<$Res,
        $Val extends GetContentCreatorsRequest>
    implements $GetContentCreatorsRequestCopyWith<$Res> {
  _$GetContentCreatorsRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetContentCreatorsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? excludeMasterPubKeys = null,
  }) {
    return _then(_value.copyWith(
      excludeMasterPubKeys: null == excludeMasterPubKeys
          ? _value.excludeMasterPubKeys
          : excludeMasterPubKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetContentCreatorsRequestImplCopyWith<$Res>
    implements $GetContentCreatorsRequestCopyWith<$Res> {
  factory _$$GetContentCreatorsRequestImplCopyWith(
          _$GetContentCreatorsRequestImpl value,
          $Res Function(_$GetContentCreatorsRequestImpl) then) =
      __$$GetContentCreatorsRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> excludeMasterPubKeys});
}

/// @nodoc
class __$$GetContentCreatorsRequestImplCopyWithImpl<$Res>
    extends _$GetContentCreatorsRequestCopyWithImpl<$Res,
        _$GetContentCreatorsRequestImpl>
    implements _$$GetContentCreatorsRequestImplCopyWith<$Res> {
  __$$GetContentCreatorsRequestImplCopyWithImpl(
      _$GetContentCreatorsRequestImpl _value,
      $Res Function(_$GetContentCreatorsRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetContentCreatorsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? excludeMasterPubKeys = null,
  }) {
    return _then(_$GetContentCreatorsRequestImpl(
      excludeMasterPubKeys: null == excludeMasterPubKeys
          ? _value._excludeMasterPubKeys
          : excludeMasterPubKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetContentCreatorsRequestImpl implements _GetContentCreatorsRequest {
  const _$GetContentCreatorsRequestImpl(
      {required final List<String> excludeMasterPubKeys})
      : _excludeMasterPubKeys = excludeMasterPubKeys;

  factory _$GetContentCreatorsRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetContentCreatorsRequestImplFromJson(json);

  final List<String> _excludeMasterPubKeys;
  @override
  List<String> get excludeMasterPubKeys {
    if (_excludeMasterPubKeys is EqualUnmodifiableListView)
      return _excludeMasterPubKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_excludeMasterPubKeys);
  }

  @override
  String toString() {
    return 'GetContentCreatorsRequest(excludeMasterPubKeys: $excludeMasterPubKeys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetContentCreatorsRequestImpl &&
            const DeepCollectionEquality()
                .equals(other._excludeMasterPubKeys, _excludeMasterPubKeys));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_excludeMasterPubKeys));

  /// Create a copy of GetContentCreatorsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetContentCreatorsRequestImplCopyWith<_$GetContentCreatorsRequestImpl>
      get copyWith => __$$GetContentCreatorsRequestImplCopyWithImpl<
          _$GetContentCreatorsRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetContentCreatorsRequestImplToJson(
      this,
    );
  }
}

abstract class _GetContentCreatorsRequest implements GetContentCreatorsRequest {
  const factory _GetContentCreatorsRequest(
          {required final List<String> excludeMasterPubKeys}) =
      _$GetContentCreatorsRequestImpl;

  factory _GetContentCreatorsRequest.fromJson(Map<String, dynamic> json) =
      _$GetContentCreatorsRequestImpl.fromJson;

  @override
  List<String> get excludeMasterPubKeys;

  /// Create a copy of GetContentCreatorsRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetContentCreatorsRequestImplCopyWith<_$GetContentCreatorsRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
