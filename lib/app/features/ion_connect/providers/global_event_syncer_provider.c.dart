// import 'package:ion/app/exceptions/exceptions.dart';
// import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
// import 'package:ion/app/features/ion_connect/ion_connect.dart';
// import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
// import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
// import 'package:ion/app/services/storage/user_preferences_service.c.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'global_event_syncer_provider.c.g.dart';

// @riverpod
// class GlobalUserEventSyncer extends _$GlobalUserEventSyncer {
//   @override
//   Future<void> build() async {
//     const latestEventTimestampKey = 'latest_event_timestamp';

//     final authState = await ref.watch(authProvider.future);

//     if (!authState.isAuthenticated) return;

//     final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
//     if (currentUserMasterPubkey == null) {
//       throw UserMasterPubkeyNotFoundException();
//     }

//     final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
//     if (eventSigner == null) {
//       throw EventSignerNotFoundException();
//     }
//     final currentUserDeviceKey = eventSigner.publicKey;

//     final latestSyncedEventCreatedAtTimestamp = ref
//         .watch(userPreferencesServiceProvider(identityKeyName: currentUserMasterPubkey))
//         .getValue<int>(latestEventTimestampKey);

//     await _fetchPreviousEvents(
//       currentUserMasterPubkey,
//       currentUserDeviceKey,
//       latestSyncedEventCreatedAtTimestamp,
//       null,
//     );
//   }

//   Future<void> _fetchPreviousEvents(
//     String currentUserMasterPubkey,
//     String currentUserDeviceKey,
//     int? since,
//     int? until,
//   ) async {
//     final requestMessage = RequestMessage(
//       filters: [
//         RequestFilter(
//           tags: {
//             '#p': [
//               [currentUserMasterPubkey],
//             ],
//           },
//           since: since,
//           until: until,
//         ),
//       ],
//     );

//     final events = ref.watch(ionConnectNotifierProvider.notifier).requestEvents(requestMessage);
//   }
// }
