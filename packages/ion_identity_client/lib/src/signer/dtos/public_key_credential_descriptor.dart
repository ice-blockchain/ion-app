class PublicKeyCredentialDescriptor {
  PublicKeyCredentialDescriptor(
    this.type,
    this.id,
  );

  factory PublicKeyCredentialDescriptor.fromJson(dynamic json) {
    return PublicKeyCredentialDescriptor(
      json['type'] as String,
      json['id'] as String,
    );
  }

  final String type;
  final String id;

  @override
  String toString() => 'PublicKeyCredentialDescriptor(type: $type, id: $id)';
}
