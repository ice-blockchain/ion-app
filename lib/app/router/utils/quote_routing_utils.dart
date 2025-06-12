// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/main_tabs/components/tab_item.dart';

class QuoteRoutingUtils {
  static TabItem getCurrentTab(BuildContext context) {
    return GoRouterState.of(context).currentTab;
  }

  static bool isInProfile(BuildContext context) {
    return getCurrentTab(context) == TabItem.profile;
  }

  static bool isInFeed(BuildContext context) {
    return getCurrentTab(context) == TabItem.feed;
  }

  static void pushRepostOptionsModal(BuildContext context, String eventReference) {
    if (isInProfile(context)) {
      RepostOptionsModalProfileRoute(eventReference: eventReference).push<void>(context);
    } else {
      RepostOptionsModalRoute(eventReference: eventReference).push<void>(context);
    }
  }

  static Future<void> pushCreateQuote(
    BuildContext context,
    String quotedEvent, {
    String? content,
    String? attachedMedia,
  }) {
    if (isInProfile(context)) {
      return CreateQuoteProfileRoute(
        quotedEvent: quotedEvent,
        content: content,
        attachedMedia: attachedMedia,
      ).push<void>(context);
    } else {
      return CreateQuoteRoute(
        quotedEvent: quotedEvent,
        content: content,
        attachedMedia: attachedMedia,
      ).push<void>(context);
    }
  }
}
