// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gas_fee.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GasFee _$GasFeeFromJson(Map<String, dynamic> json) {
  return _GasFee.fromJson(json);
}

/// @nodoc
mixin _$GasFee {
  @NumberToStringConverter()
  String get maxFeePerGas => throw _privateConstructorUsedError;
  @NumberToStringConverter()
  String get maxPriorityFeePerGas => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration? get waitTime => throw _privateConstructorUsedError;

  /// Serializes this GasFee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GasFee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GasFeeCopyWith<GasFee> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GasFeeCopyWith<$Res> {
  factory $GasFeeCopyWith(GasFee value, $Res Function(GasFee) then) =
      _$GasFeeCopyWithImpl<$Res, GasFee>;
  @useResult
  $Res call(
      {@NumberToStringConverter() String maxFeePerGas,
      @NumberToStringConverter() String maxPriorityFeePerGas,
      @DurationConverter() Duration? waitTime});
}

/// @nodoc
class _$GasFeeCopyWithImpl<$Res, $Val extends GasFee>
    implements $GasFeeCopyWith<$Res> {
  _$GasFeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GasFee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxFeePerGas = null,
    Object? maxPriorityFeePerGas = null,
    Object? waitTime = freezed,
  }) {
    return _then(_value.copyWith(
      maxFeePerGas: null == maxFeePerGas
          ? _value.maxFeePerGas
          : maxFeePerGas // ignore: cast_nullable_to_non_nullable
              as String,
      maxPriorityFeePerGas: null == maxPriorityFeePerGas
          ? _value.maxPriorityFeePerGas
          : maxPriorityFeePerGas // ignore: cast_nullable_to_non_nullable
              as String,
      waitTime: freezed == waitTime
          ? _value.waitTime
          : waitTime // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GasFeeImplCopyWith<$Res> implements $GasFeeCopyWith<$Res> {
  factory _$$GasFeeImplCopyWith(
          _$GasFeeImpl value, $Res Function(_$GasFeeImpl) then) =
      __$$GasFeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@NumberToStringConverter() String maxFeePerGas,
      @NumberToStringConverter() String maxPriorityFeePerGas,
      @DurationConverter() Duration? waitTime});
}

/// @nodoc
class __$$GasFeeImplCopyWithImpl<$Res>
    extends _$GasFeeCopyWithImpl<$Res, _$GasFeeImpl>
    implements _$$GasFeeImplCopyWith<$Res> {
  __$$GasFeeImplCopyWithImpl(
      _$GasFeeImpl _value, $Res Function(_$GasFeeImpl) _then)
      : super(_value, _then);

  /// Create a copy of GasFee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxFeePerGas = null,
    Object? maxPriorityFeePerGas = null,
    Object? waitTime = freezed,
  }) {
    return _then(_$GasFeeImpl(
      maxFeePerGas: null == maxFeePerGas
          ? _value.maxFeePerGas
          : maxFeePerGas // ignore: cast_nullable_to_non_nullable
              as String,
      maxPriorityFeePerGas: null == maxPriorityFeePerGas
          ? _value.maxPriorityFeePerGas
          : maxPriorityFeePerGas // ignore: cast_nullable_to_non_nullable
              as String,
      waitTime: freezed == waitTime
          ? _value.waitTime
          : waitTime // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GasFeeImpl implements _GasFee {
  const _$GasFeeImpl(
      {@NumberToStringConverter() required this.maxFeePerGas,
      @NumberToStringConverter() required this.maxPriorityFeePerGas,
      @DurationConverter() this.waitTime});

  factory _$GasFeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GasFeeImplFromJson(json);

  @override
  @NumberToStringConverter()
  final String maxFeePerGas;
  @override
  @NumberToStringConverter()
  final String maxPriorityFeePerGas;
  @override
  @DurationConverter()
  final Duration? waitTime;

  @override
  String toString() {
    return 'GasFee(maxFeePerGas: $maxFeePerGas, maxPriorityFeePerGas: $maxPriorityFeePerGas, waitTime: $waitTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GasFeeImpl &&
            (identical(other.maxFeePerGas, maxFeePerGas) ||
                other.maxFeePerGas == maxFeePerGas) &&
            (identical(other.maxPriorityFeePerGas, maxPriorityFeePerGas) ||
                other.maxPriorityFeePerGas == maxPriorityFeePerGas) &&
            (identical(other.waitTime, waitTime) ||
                other.waitTime == waitTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, maxFeePerGas, maxPriorityFeePerGas, waitTime);

  /// Create a copy of GasFee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GasFeeImplCopyWith<_$GasFeeImpl> get copyWith =>
      __$$GasFeeImplCopyWithImpl<_$GasFeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GasFeeImplToJson(
      this,
    );
  }
}

abstract class _GasFee implements GasFee {
  const factory _GasFee(
      {@NumberToStringConverter() required final String maxFeePerGas,
      @NumberToStringConverter() required final String maxPriorityFeePerGas,
      @DurationConverter() final Duration? waitTime}) = _$GasFeeImpl;

  factory _GasFee.fromJson(Map<String, dynamic> json) = _$GasFeeImpl.fromJson;

  @override
  @NumberToStringConverter()
  String get maxFeePerGas;
  @override
  @NumberToStringConverter()
  String get maxPriorityFeePerGas;
  @override
  @DurationConverter()
  Duration? get waitTime;

  /// Create a copy of GasFee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GasFeeImplCopyWith<_$GasFeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
