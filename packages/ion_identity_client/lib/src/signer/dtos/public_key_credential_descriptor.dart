import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_key_credential_descriptor.g.dart';

@JsonSerializable()
class PublicKeyCredentialDescriptor {
  PublicKeyCredentialDescriptor(
    this.type,
    this.id,
  );

  factory PublicKeyCredentialDescriptor.fromJson(JsonObject json) {
    return _$PublicKeyCredentialDescriptorFromJson(json);
  }

  final String type;
  final String id;

  JsonObject toJson() => _$PublicKeyCredentialDescriptorToJson(this);
}
