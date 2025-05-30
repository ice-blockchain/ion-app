// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'derive_request.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeriveRequest _$DeriveRequestFromJson(Map<String, dynamic> json) {
  return _DeriveRequest.fromJson(json);
}

/// @nodoc
mixin _$DeriveRequest {
  String get domain => throw _privateConstructorUsedError;
  String get seed => throw _privateConstructorUsedError;

  /// Serializes this DeriveRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeriveRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeriveRequestCopyWith<DeriveRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeriveRequestCopyWith<$Res> {
  factory $DeriveRequestCopyWith(
          DeriveRequest value, $Res Function(DeriveRequest) then) =
      _$DeriveRequestCopyWithImpl<$Res, DeriveRequest>;
  @useResult
  $Res call({String domain, String seed});
}

/// @nodoc
class _$DeriveRequestCopyWithImpl<$Res, $Val extends DeriveRequest>
    implements $DeriveRequestCopyWith<$Res> {
  _$DeriveRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeriveRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? domain = null,
    Object? seed = null,
  }) {
    return _then(_value.copyWith(
      domain: null == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String,
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeriveRequestImplCopyWith<$Res>
    implements $DeriveRequestCopyWith<$Res> {
  factory _$$DeriveRequestImplCopyWith(
          _$DeriveRequestImpl value, $Res Function(_$DeriveRequestImpl) then) =
      __$$DeriveRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String domain, String seed});
}

/// @nodoc
class __$$DeriveRequestImplCopyWithImpl<$Res>
    extends _$DeriveRequestCopyWithImpl<$Res, _$DeriveRequestImpl>
    implements _$$DeriveRequestImplCopyWith<$Res> {
  __$$DeriveRequestImplCopyWithImpl(
      _$DeriveRequestImpl _value, $Res Function(_$DeriveRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeriveRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? domain = null,
    Object? seed = null,
  }) {
    return _then(_$DeriveRequestImpl(
      domain: null == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String,
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeriveRequestImpl implements _DeriveRequest {
  _$DeriveRequestImpl({required this.domain, required this.seed});

  factory _$DeriveRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeriveRequestImplFromJson(json);

  @override
  final String domain;
  @override
  final String seed;

  @override
  String toString() {
    return 'DeriveRequest(domain: $domain, seed: $seed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeriveRequestImpl &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.seed, seed) || other.seed == seed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, domain, seed);

  /// Create a copy of DeriveRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeriveRequestImplCopyWith<_$DeriveRequestImpl> get copyWith =>
      __$$DeriveRequestImplCopyWithImpl<_$DeriveRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeriveRequestImplToJson(
      this,
    );
  }
}

abstract class _DeriveRequest implements DeriveRequest {
  factory _DeriveRequest(
      {required final String domain,
      required final String seed}) = _$DeriveRequestImpl;

  factory _DeriveRequest.fromJson(Map<String, dynamic> json) =
      _$DeriveRequestImpl.fromJson;

  @override
  String get domain;
  @override
  String get seed;

  /// Create a copy of DeriveRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeriveRequestImplCopyWith<_$DeriveRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
