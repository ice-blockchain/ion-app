// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/providers/ion_connect/ion_connect_protocol_identifier_type.dart';

class ShareableIdentifier {
  ShareableIdentifier({
    required this.prefix,
    required this.special,
    this.relays = const [],
    this.author,
    this.kind,
  });
  final IonConnectProtocolIdentifierType prefix;
  final String special;
  List<String> relays;
  String? author;
  int? kind;
}
