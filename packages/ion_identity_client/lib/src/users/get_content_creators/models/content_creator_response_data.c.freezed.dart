// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_creator_response_data.c.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentCreatorResponseData _$ContentCreatorResponseDataFromJson(
    Map<String, dynamic> json) {
  return _ContentCreatorResponseData.fromJson(json);
}

/// @nodoc
mixin _$ContentCreatorResponseData {
  String get masterPubKey => throw _privateConstructorUsedError;
  List<String> get ionConnectRelays => throw _privateConstructorUsedError;

  /// Serializes this ContentCreatorResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentCreatorResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentCreatorResponseDataCopyWith<ContentCreatorResponseData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentCreatorResponseDataCopyWith<$Res> {
  factory $ContentCreatorResponseDataCopyWith(ContentCreatorResponseData value,
          $Res Function(ContentCreatorResponseData) then) =
      _$ContentCreatorResponseDataCopyWithImpl<$Res,
          ContentCreatorResponseData>;
  @useResult
  $Res call({String masterPubKey, List<String> ionConnectRelays});
}

/// @nodoc
class _$ContentCreatorResponseDataCopyWithImpl<$Res,
        $Val extends ContentCreatorResponseData>
    implements $ContentCreatorResponseDataCopyWith<$Res> {
  _$ContentCreatorResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentCreatorResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterPubKey = null,
    Object? ionConnectRelays = null,
  }) {
    return _then(_value.copyWith(
      masterPubKey: null == masterPubKey
          ? _value.masterPubKey
          : masterPubKey // ignore: cast_nullable_to_non_nullable
              as String,
      ionConnectRelays: null == ionConnectRelays
          ? _value.ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentCreatorResponseDataImplCopyWith<$Res>
    implements $ContentCreatorResponseDataCopyWith<$Res> {
  factory _$$ContentCreatorResponseDataImplCopyWith(
          _$ContentCreatorResponseDataImpl value,
          $Res Function(_$ContentCreatorResponseDataImpl) then) =
      __$$ContentCreatorResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String masterPubKey, List<String> ionConnectRelays});
}

/// @nodoc
class __$$ContentCreatorResponseDataImplCopyWithImpl<$Res>
    extends _$ContentCreatorResponseDataCopyWithImpl<$Res,
        _$ContentCreatorResponseDataImpl>
    implements _$$ContentCreatorResponseDataImplCopyWith<$Res> {
  __$$ContentCreatorResponseDataImplCopyWithImpl(
      _$ContentCreatorResponseDataImpl _value,
      $Res Function(_$ContentCreatorResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentCreatorResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterPubKey = null,
    Object? ionConnectRelays = null,
  }) {
    return _then(_$ContentCreatorResponseDataImpl(
      masterPubKey: null == masterPubKey
          ? _value.masterPubKey
          : masterPubKey // ignore: cast_nullable_to_non_nullable
              as String,
      ionConnectRelays: null == ionConnectRelays
          ? _value._ionConnectRelays
          : ionConnectRelays // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentCreatorResponseDataImpl implements _ContentCreatorResponseData {
  const _$ContentCreatorResponseDataImpl(
      {required this.masterPubKey,
      required final List<String> ionConnectRelays})
      : _ionConnectRelays = ionConnectRelays;

  factory _$ContentCreatorResponseDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ContentCreatorResponseDataImplFromJson(json);

  @override
  final String masterPubKey;
  final List<String> _ionConnectRelays;
  @override
  List<String> get ionConnectRelays {
    if (_ionConnectRelays is EqualUnmodifiableListView)
      return _ionConnectRelays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ionConnectRelays);
  }

  @override
  String toString() {
    return 'ContentCreatorResponseData(masterPubKey: $masterPubKey, ionConnectRelays: $ionConnectRelays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentCreatorResponseDataImpl &&
            (identical(other.masterPubKey, masterPubKey) ||
                other.masterPubKey == masterPubKey) &&
            const DeepCollectionEquality()
                .equals(other._ionConnectRelays, _ionConnectRelays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, masterPubKey,
      const DeepCollectionEquality().hash(_ionConnectRelays));

  /// Create a copy of ContentCreatorResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentCreatorResponseDataImplCopyWith<_$ContentCreatorResponseDataImpl>
      get copyWith => __$$ContentCreatorResponseDataImplCopyWithImpl<
          _$ContentCreatorResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentCreatorResponseDataImplToJson(
      this,
    );
  }
}

abstract class _ContentCreatorResponseData
    implements ContentCreatorResponseData {
  const factory _ContentCreatorResponseData(
          {required final String masterPubKey,
          required final List<String> ionConnectRelays}) =
      _$ContentCreatorResponseDataImpl;

  factory _ContentCreatorResponseData.fromJson(Map<String, dynamic> json) =
      _$ContentCreatorResponseDataImpl.fromJson;

  @override
  String get masterPubKey;
  @override
  List<String> get ionConnectRelays;

  /// Create a copy of ContentCreatorResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentCreatorResponseDataImplCopyWith<_$ContentCreatorResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
