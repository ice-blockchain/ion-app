// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_connect/ion_connect_protocol_identifer_type.dart';

class ShareableIdentifier {
  ShareableIdentifier({
    required this.prefix,
    required this.special,
    this.relays = const [],
    this.author,
    this.kind,
  });
  final IonConnectProtocolIdentiferType prefix;
  final String special;
  List<String> relays;
  String? author;
  int? kind;
}
