// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/providers/dao/conversation_message_reaction_dao_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

bool useHasReaction(EventMessage eventMessage, WidgetRef ref) {
  final reactionsStream = useMemoized(
    () => ref.read(conversationMessageReactionDaoProvider).messageReactions(eventMessage),
    [eventMessage],
  );

  return useStream(reactionsStream).data?.isNotEmpty ?? false;
}
