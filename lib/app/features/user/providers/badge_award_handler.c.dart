import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_event_handler.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/badges/badge_award.c.dart';
import 'package:ion/app/features/user/model/badges/badge_definition.c.dart';
import 'package:ion/app/features/user/model/badges/profile_badges.c.dart';
import 'package:ion/app/features/user/providers/badges_notifier.c.dart';
import 'package:ion/app/features/user/providers/service_pubkeys_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'badge_award_handler.c.g.dart';

class BadgeAwardHandler extends GlobalSubscriptionEventHandler {
  BadgeAwardHandler(this.ref);

  final Ref ref;

  @override
  bool canHandle(EventMessage eventMessage) {
    return eventMessage.kind == BadgeAwardEntity.kind;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      return;
    }

    final isVerified = ref.read(isUserVerifiedProvider(currentPubkey)).valueOrNull;
    if (isVerified == null || isVerified) {
      return;
    }

    final badgeAwardEntity = await ref.read(badgeAwardProvider(currentPubkey).future);

    if (badgeAwardEntity == null) {
      return;
    }

    final pubkeys = await ref.watch(servicePubkeysProvider.future);
    final eventRef = badgeAwardEntity.data.badgeDefinitionRef;
    if (eventRef.kind == BadgeDefinitionEntity.kind &&
        eventRef.dTag == BadgeDefinitionEntity.verifiedBadgeDTag &&
        (pubkeys.isEmpty || pubkeys.contains(eventRef.pubkey))) {
      final updatedData = await ref.read(
        updatedProfileBadgesProvider(
          BadgeEntry(
            definitionRef: badgeAwardEntity.data.badgeDefinitionRef,
            awardId: badgeAwardEntity.id,
          ),
          currentPubkey,
        ).future,
      );
      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([updatedData]);
    }
  }
}

@riverpod
BadgeAwardHandler badgeAwardHandler(Ref ref) {
  return BadgeAwardHandler(ref);
}
