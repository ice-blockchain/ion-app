class UserInformation {
  UserInformation(this.id, this.displayName, this.name);

  factory UserInformation.fromJson(dynamic json) {
    return UserInformation(
      json['id'] as String,
      json['displayName'] as String,
      json['name'] as String,
    );
  }

  final String id;
  final String displayName;
  final String name;
}
