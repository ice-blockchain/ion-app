import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/utils/types.dart';

class ListWalletsResponse {
  ListWalletsResponse({
    required this.items,
  });

  factory ListWalletsResponse.fromJson(JsonObject json) {
    return ListWalletsResponse(
      items: List<Wallet>.from(
        (json['items'] as List<dynamic>).map<Wallet>(
          (x) => Wallet.fromJson(x as JsonObject),
        ),
      ),
    );
  }

  final List<Wallet> items;

  @override
  String toString() => 'ListWalletsResponse(items: $items)';
}
