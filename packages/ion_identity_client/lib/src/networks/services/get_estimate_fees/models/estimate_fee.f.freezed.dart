// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estimate_fee.f.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EstimateFee _$EstimateFeeFromJson(Map<String, dynamic> json) {
  return _EstimateFee.fromJson(json);
}

/// @nodoc
mixin _$EstimateFee {
  String get network => throw _privateConstructorUsedError;
  int? get estimatedBaseFee => throw _privateConstructorUsedError;
  String? get kind => throw _privateConstructorUsedError;
  NetworkFee? get fast => throw _privateConstructorUsedError;
  NetworkFee? get standard => throw _privateConstructorUsedError;
  NetworkFee? get slow => throw _privateConstructorUsedError;

  /// Serializes this EstimateFee to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EstimateFee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EstimateFeeCopyWith<EstimateFee> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EstimateFeeCopyWith<$Res> {
  factory $EstimateFeeCopyWith(
          EstimateFee value, $Res Function(EstimateFee) then) =
      _$EstimateFeeCopyWithImpl<$Res, EstimateFee>;
  @useResult
  $Res call(
      {String network,
      int? estimatedBaseFee,
      String? kind,
      NetworkFee? fast,
      NetworkFee? standard,
      NetworkFee? slow});

  $NetworkFeeCopyWith<$Res>? get fast;
  $NetworkFeeCopyWith<$Res>? get standard;
  $NetworkFeeCopyWith<$Res>? get slow;
}

/// @nodoc
class _$EstimateFeeCopyWithImpl<$Res, $Val extends EstimateFee>
    implements $EstimateFeeCopyWith<$Res> {
  _$EstimateFeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EstimateFee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? network = null,
    Object? estimatedBaseFee = freezed,
    Object? kind = freezed,
    Object? fast = freezed,
    Object? standard = freezed,
    Object? slow = freezed,
  }) {
    return _then(_value.copyWith(
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedBaseFee: freezed == estimatedBaseFee
          ? _value.estimatedBaseFee
          : estimatedBaseFee // ignore: cast_nullable_to_non_nullable
              as int?,
      kind: freezed == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String?,
      fast: freezed == fast
          ? _value.fast
          : fast // ignore: cast_nullable_to_non_nullable
              as NetworkFee?,
      standard: freezed == standard
          ? _value.standard
          : standard // ignore: cast_nullable_to_non_nullable
              as NetworkFee?,
      slow: freezed == slow
          ? _value.slow
          : slow // ignore: cast_nullable_to_non_nullable
              as NetworkFee?,
    ) as $Val);
  }

  /// Create a copy of EstimateFee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NetworkFeeCopyWith<$Res>? get fast {
    if (_value.fast == null) {
      return null;
    }

    return $NetworkFeeCopyWith<$Res>(_value.fast!, (value) {
      return _then(_value.copyWith(fast: value) as $Val);
    });
  }

  /// Create a copy of EstimateFee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NetworkFeeCopyWith<$Res>? get standard {
    if (_value.standard == null) {
      return null;
    }

    return $NetworkFeeCopyWith<$Res>(_value.standard!, (value) {
      return _then(_value.copyWith(standard: value) as $Val);
    });
  }

  /// Create a copy of EstimateFee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NetworkFeeCopyWith<$Res>? get slow {
    if (_value.slow == null) {
      return null;
    }

    return $NetworkFeeCopyWith<$Res>(_value.slow!, (value) {
      return _then(_value.copyWith(slow: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EstimateFeeImplCopyWith<$Res>
    implements $EstimateFeeCopyWith<$Res> {
  factory _$$EstimateFeeImplCopyWith(
          _$EstimateFeeImpl value, $Res Function(_$EstimateFeeImpl) then) =
      __$$EstimateFeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String network,
      int? estimatedBaseFee,
      String? kind,
      NetworkFee? fast,
      NetworkFee? standard,
      NetworkFee? slow});

  @override
  $NetworkFeeCopyWith<$Res>? get fast;
  @override
  $NetworkFeeCopyWith<$Res>? get standard;
  @override
  $NetworkFeeCopyWith<$Res>? get slow;
}

/// @nodoc
class __$$EstimateFeeImplCopyWithImpl<$Res>
    extends _$EstimateFeeCopyWithImpl<$Res, _$EstimateFeeImpl>
    implements _$$EstimateFeeImplCopyWith<$Res> {
  __$$EstimateFeeImplCopyWithImpl(
      _$EstimateFeeImpl _value, $Res Function(_$EstimateFeeImpl) _then)
      : super(_value, _then);

  /// Create a copy of EstimateFee
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? network = null,
    Object? estimatedBaseFee = freezed,
    Object? kind = freezed,
    Object? fast = freezed,
    Object? standard = freezed,
    Object? slow = freezed,
  }) {
    return _then(_$EstimateFeeImpl(
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedBaseFee: freezed == estimatedBaseFee
          ? _value.estimatedBaseFee
          : estimatedBaseFee // ignore: cast_nullable_to_non_nullable
              as int?,
      kind: freezed == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String?,
      fast: freezed == fast
          ? _value.fast
          : fast // ignore: cast_nullable_to_non_nullable
              as NetworkFee?,
      standard: freezed == standard
          ? _value.standard
          : standard // ignore: cast_nullable_to_non_nullable
              as NetworkFee?,
      slow: freezed == slow
          ? _value.slow
          : slow // ignore: cast_nullable_to_non_nullable
              as NetworkFee?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EstimateFeeImpl implements _EstimateFee {
  _$EstimateFeeImpl(
      {required this.network,
      this.estimatedBaseFee,
      this.kind,
      this.fast,
      this.standard,
      this.slow});

  factory _$EstimateFeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EstimateFeeImplFromJson(json);

  @override
  final String network;
  @override
  final int? estimatedBaseFee;
  @override
  final String? kind;
  @override
  final NetworkFee? fast;
  @override
  final NetworkFee? standard;
  @override
  final NetworkFee? slow;

  @override
  String toString() {
    return 'EstimateFee(network: $network, estimatedBaseFee: $estimatedBaseFee, kind: $kind, fast: $fast, standard: $standard, slow: $slow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EstimateFeeImpl &&
            (identical(other.network, network) || other.network == network) &&
            (identical(other.estimatedBaseFee, estimatedBaseFee) ||
                other.estimatedBaseFee == estimatedBaseFee) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.fast, fast) || other.fast == fast) &&
            (identical(other.standard, standard) ||
                other.standard == standard) &&
            (identical(other.slow, slow) || other.slow == slow));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, network, estimatedBaseFee, kind, fast, standard, slow);

  /// Create a copy of EstimateFee
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EstimateFeeImplCopyWith<_$EstimateFeeImpl> get copyWith =>
      __$$EstimateFeeImplCopyWithImpl<_$EstimateFeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EstimateFeeImplToJson(
      this,
    );
  }
}

abstract class _EstimateFee implements EstimateFee {
  factory _EstimateFee(
      {required final String network,
      final int? estimatedBaseFee,
      final String? kind,
      final NetworkFee? fast,
      final NetworkFee? standard,
      final NetworkFee? slow}) = _$EstimateFeeImpl;

  factory _EstimateFee.fromJson(Map<String, dynamic> json) =
      _$EstimateFeeImpl.fromJson;

  @override
  String get network;
  @override
  int? get estimatedBaseFee;
  @override
  String? get kind;
  @override
  NetworkFee? get fast;
  @override
  NetworkFee? get standard;
  @override
  NetworkFee? get slow;

  /// Create a copy of EstimateFee
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EstimateFeeImplCopyWith<_$EstimateFeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
