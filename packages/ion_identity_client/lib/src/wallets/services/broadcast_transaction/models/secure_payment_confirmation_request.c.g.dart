// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_payment_confirmation_request.c.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SecurePaymentConfirmationRequestImpl
    _$$SecurePaymentConfirmationRequestImplFromJson(
            Map<String, dynamic> json) =>
        _$SecurePaymentConfirmationRequestImpl(
          kind: json['kind'] as String,
          transaction: json['transaction'] as String,
          authorization: json['authorization'] as String?,
        );

Map<String, dynamic> _$$SecurePaymentConfirmationRequestImplToJson(
        _$SecurePaymentConfirmationRequestImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'transaction': instance.transaction,
      if (instance.authorization case final value?) 'authorization': value,
    };
