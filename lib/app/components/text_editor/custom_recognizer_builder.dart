// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

GestureRecognizer? customRecognizerBuilder(
  BuildContext context,
  Attribute<dynamic> attribute, {
  bool isEditing = false,
  List<UserMetadataEntity?> users = const [],
}) {
  if (attribute.key == HashtagAttribute.attributeKey ||
      attribute.key == CashtagAttribute.attributeKey) {
    return TapGestureRecognizer()
      ..onTap = isEditing
          ? null
          : () {
              FeedAdvancedSearchRoute(query: attribute.value as String).go(context);
            };
  }
  if (attribute.key == MentionAttribute.attributeKey) {
    return TapGestureRecognizer()
      ..onTap = isEditing
          ? null
          : () {
              final mentionedName = (attribute.value as String).substring(1);
              final user = users.firstWhereOrNull(
                (user) => user?.data.name == mentionedName,
              );
              if (user == null) return;
              ProfileRoute(pubkey: user.masterPubkey).push<void>(context);
            };
  }
  return null;
}
