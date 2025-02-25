// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_connect/nip21/nip19_prefix.dart';

class ShareableIdentifiers {
  ShareableIdentifiers({
    required this.prefix,
    required this.special,
    this.relays = const [],
    this.author,
    this.kind,
  });
  final Nip19Prefix prefix;
  final String special;
  List<String> relays;
  String? author;
  int? kind;
}
