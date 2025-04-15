// SPDX-License-Identifier: ice License 1.0

// import 'package:flutter/services.dart' show FontLoader, rootBundle;
// import 'package:ion/app/services/logger/logger.dart';

// /// Preloads the fallback emoji font to avoid delay when fallback is triggered.
// /// This should be called early in the app initialization.
// Future<void> preloadFallbackEmojiFont() async {
//   try {
//     final fontLoader = FontLoader('NotoColorEmoji')
//       ..addFont(rootBundle.load('assets/fonts/NotoColorEmoji-Regular.ttf'));
//     await fontLoader.load();
//   } catch (e, st) {
//     Logger.error(e, stackTrace: st, message: 'Failed to preload fallback emoji font');
//   }
// }
