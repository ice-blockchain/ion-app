import 'package:json_annotation/json_annotation.dart';

part 'list_wallets_request.g.dart';

@JsonSerializable()
class ListWalletsRequest {
  ListWalletsRequest({
    required this.username,
    required this.paginationToken,
  });

  factory ListWalletsRequest.fromJson(Map<String, dynamic> json) =>
      _$ListWalletsRequestFromJson(json);

  final String username;

  @JsonKey(includeIfNull: false)
  final String? paginationToken;

  Map<String, dynamic> toJson() => _$ListWalletsRequestToJson(this);
}
