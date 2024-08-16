import 'package:ion_identity_client/src/utils/types.dart';

class User {
  User({
    required this.id,
    required this.username,
    required this.orgId,
  });

  factory User.fromJson(JsonObject map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      orgId: map['orgId'] as String,
    );
  }

  final String id;
  final String username;
  final String orgId;

  JsonObject toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'orgId': orgId,
    };
  }

  @override
  String toString() => 'User(id: $id, username: $username, orgId: $orgId)';
}
