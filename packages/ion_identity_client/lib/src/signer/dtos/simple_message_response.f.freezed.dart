// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simple_message_response.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SimpleMessageResponse _$SimpleMessageResponseFromJson(
    Map<String, dynamic> json) {
  return _SimpleMessageResponse.fromJson(json);
}

/// @nodoc
mixin _$SimpleMessageResponse {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this SimpleMessageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SimpleMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SimpleMessageResponseCopyWith<SimpleMessageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimpleMessageResponseCopyWith<$Res> {
  factory $SimpleMessageResponseCopyWith(SimpleMessageResponse value,
          $Res Function(SimpleMessageResponse) then) =
      _$SimpleMessageResponseCopyWithImpl<$Res, SimpleMessageResponse>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$SimpleMessageResponseCopyWithImpl<$Res,
        $Val extends SimpleMessageResponse>
    implements $SimpleMessageResponseCopyWith<$Res> {
  _$SimpleMessageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SimpleMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SimpleMessageResponseImplCopyWith<$Res>
    implements $SimpleMessageResponseCopyWith<$Res> {
  factory _$$SimpleMessageResponseImplCopyWith(
          _$SimpleMessageResponseImpl value,
          $Res Function(_$SimpleMessageResponseImpl) then) =
      __$$SimpleMessageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SimpleMessageResponseImplCopyWithImpl<$Res>
    extends _$SimpleMessageResponseCopyWithImpl<$Res,
        _$SimpleMessageResponseImpl>
    implements _$$SimpleMessageResponseImplCopyWith<$Res> {
  __$$SimpleMessageResponseImplCopyWithImpl(_$SimpleMessageResponseImpl _value,
      $Res Function(_$SimpleMessageResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SimpleMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SimpleMessageResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SimpleMessageResponseImpl implements _SimpleMessageResponse {
  const _$SimpleMessageResponseImpl({required this.message});

  factory _$SimpleMessageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SimpleMessageResponseImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'SimpleMessageResponse(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimpleMessageResponseImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SimpleMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimpleMessageResponseImplCopyWith<_$SimpleMessageResponseImpl>
      get copyWith => __$$SimpleMessageResponseImplCopyWithImpl<
          _$SimpleMessageResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SimpleMessageResponseImplToJson(
      this,
    );
  }
}

abstract class _SimpleMessageResponse implements SimpleMessageResponse {
  const factory _SimpleMessageResponse({required final String message}) =
      _$SimpleMessageResponseImpl;

  factory _SimpleMessageResponse.fromJson(Map<String, dynamic> json) =
      _$SimpleMessageResponseImpl.fromJson;

  @override
  String get message;

  /// Create a copy of SimpleMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimpleMessageResponseImplCopyWith<_$SimpleMessageResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
