// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_content_creators_response.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetContentCreatorsResponse _$GetContentCreatorsResponseFromJson(
    Map<String, dynamic> json) {
  return _GetContentCreatorsResponse.fromJson(json);
}

/// @nodoc
mixin _$GetContentCreatorsResponse {
  List<ContentCreatorResponseData> get creators =>
      throw _privateConstructorUsedError;

  /// Serializes this GetContentCreatorsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetContentCreatorsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetContentCreatorsResponseCopyWith<GetContentCreatorsResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetContentCreatorsResponseCopyWith<$Res> {
  factory $GetContentCreatorsResponseCopyWith(GetContentCreatorsResponse value,
          $Res Function(GetContentCreatorsResponse) then) =
      _$GetContentCreatorsResponseCopyWithImpl<$Res,
          GetContentCreatorsResponse>;
  @useResult
  $Res call({List<ContentCreatorResponseData> creators});
}

/// @nodoc
class _$GetContentCreatorsResponseCopyWithImpl<$Res,
        $Val extends GetContentCreatorsResponse>
    implements $GetContentCreatorsResponseCopyWith<$Res> {
  _$GetContentCreatorsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetContentCreatorsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creators = null,
  }) {
    return _then(_value.copyWith(
      creators: null == creators
          ? _value.creators
          : creators // ignore: cast_nullable_to_non_nullable
              as List<ContentCreatorResponseData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetContentCreatorsResponseImplCopyWith<$Res>
    implements $GetContentCreatorsResponseCopyWith<$Res> {
  factory _$$GetContentCreatorsResponseImplCopyWith(
          _$GetContentCreatorsResponseImpl value,
          $Res Function(_$GetContentCreatorsResponseImpl) then) =
      __$$GetContentCreatorsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ContentCreatorResponseData> creators});
}

/// @nodoc
class __$$GetContentCreatorsResponseImplCopyWithImpl<$Res>
    extends _$GetContentCreatorsResponseCopyWithImpl<$Res,
        _$GetContentCreatorsResponseImpl>
    implements _$$GetContentCreatorsResponseImplCopyWith<$Res> {
  __$$GetContentCreatorsResponseImplCopyWithImpl(
      _$GetContentCreatorsResponseImpl _value,
      $Res Function(_$GetContentCreatorsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetContentCreatorsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creators = null,
  }) {
    return _then(_$GetContentCreatorsResponseImpl(
      null == creators
          ? _value._creators
          : creators // ignore: cast_nullable_to_non_nullable
              as List<ContentCreatorResponseData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetContentCreatorsResponseImpl extends _GetContentCreatorsResponse {
  const _$GetContentCreatorsResponseImpl(
      final List<ContentCreatorResponseData> creators)
      : _creators = creators,
        super._();

  factory _$GetContentCreatorsResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GetContentCreatorsResponseImplFromJson(json);

  final List<ContentCreatorResponseData> _creators;
  @override
  List<ContentCreatorResponseData> get creators {
    if (_creators is EqualUnmodifiableListView) return _creators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_creators);
  }

  @override
  String toString() {
    return 'GetContentCreatorsResponse(creators: $creators)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetContentCreatorsResponseImpl &&
            const DeepCollectionEquality().equals(other._creators, _creators));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_creators));

  /// Create a copy of GetContentCreatorsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetContentCreatorsResponseImplCopyWith<_$GetContentCreatorsResponseImpl>
      get copyWith => __$$GetContentCreatorsResponseImplCopyWithImpl<
          _$GetContentCreatorsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetContentCreatorsResponseImplToJson(
      this,
    );
  }
}

abstract class _GetContentCreatorsResponse extends GetContentCreatorsResponse {
  const factory _GetContentCreatorsResponse(
          final List<ContentCreatorResponseData> creators) =
      _$GetContentCreatorsResponseImpl;
  const _GetContentCreatorsResponse._() : super._();

  factory _GetContentCreatorsResponse.fromJson(Map<String, dynamic> json) =
      _$GetContentCreatorsResponseImpl.fromJson;

  @override
  List<ContentCreatorResponseData> get creators;

  /// Create a copy of GetContentCreatorsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetContentCreatorsResponseImplCopyWith<_$GetContentCreatorsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
