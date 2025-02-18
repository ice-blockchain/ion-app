// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/providers/e2ee_messages_subscriber.c.dart';

class EarlyInitialization extends ConsumerWidget {
  const EarlyInitialization({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(e2eeMessagesSubscriberProvider);
    return child;
  }
}
