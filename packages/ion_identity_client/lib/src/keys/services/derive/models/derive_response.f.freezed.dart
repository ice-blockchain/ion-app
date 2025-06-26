// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'derive_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeriveResponse _$DeriveResponseFromJson(Map<String, dynamic> json) {
  return _DeriveResponse.fromJson(json);
}

/// @nodoc
mixin _$DeriveResponse {
  String get output => throw _privateConstructorUsedError;

  /// Serializes this DeriveResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeriveResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeriveResponseCopyWith<DeriveResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeriveResponseCopyWith<$Res> {
  factory $DeriveResponseCopyWith(
          DeriveResponse value, $Res Function(DeriveResponse) then) =
      _$DeriveResponseCopyWithImpl<$Res, DeriveResponse>;
  @useResult
  $Res call({String output});
}

/// @nodoc
class _$DeriveResponseCopyWithImpl<$Res, $Val extends DeriveResponse>
    implements $DeriveResponseCopyWith<$Res> {
  _$DeriveResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeriveResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? output = null,
  }) {
    return _then(_value.copyWith(
      output: null == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeriveResponseImplCopyWith<$Res>
    implements $DeriveResponseCopyWith<$Res> {
  factory _$$DeriveResponseImplCopyWith(_$DeriveResponseImpl value,
          $Res Function(_$DeriveResponseImpl) then) =
      __$$DeriveResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String output});
}

/// @nodoc
class __$$DeriveResponseImplCopyWithImpl<$Res>
    extends _$DeriveResponseCopyWithImpl<$Res, _$DeriveResponseImpl>
    implements _$$DeriveResponseImplCopyWith<$Res> {
  __$$DeriveResponseImplCopyWithImpl(
      _$DeriveResponseImpl _value, $Res Function(_$DeriveResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeriveResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? output = null,
  }) {
    return _then(_$DeriveResponseImpl(
      output: null == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeriveResponseImpl implements _DeriveResponse {
  _$DeriveResponseImpl({required this.output});

  factory _$DeriveResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeriveResponseImplFromJson(json);

  @override
  final String output;

  @override
  String toString() {
    return 'DeriveResponse(output: $output)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeriveResponseImpl &&
            (identical(other.output, output) || other.output == output));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, output);

  /// Create a copy of DeriveResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeriveResponseImplCopyWith<_$DeriveResponseImpl> get copyWith =>
      __$$DeriveResponseImplCopyWithImpl<_$DeriveResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeriveResponseImplToJson(
      this,
    );
  }
}

abstract class _DeriveResponse implements DeriveResponse {
  factory _DeriveResponse({required final String output}) =
      _$DeriveResponseImpl;

  factory _DeriveResponse.fromJson(Map<String, dynamic> json) =
      _$DeriveResponseImpl.fromJson;

  @override
  String get output;

  /// Create a copy of DeriveResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeriveResponseImplCopyWith<_$DeriveResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
