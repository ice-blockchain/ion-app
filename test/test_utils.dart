// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:meta/meta.dart';

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

@isTestGroup
void parameterizedGroup<T>(Object description, List<T> testData, void Function(T t) tester) {
  group(
    description,
    () {
      for (final t in testData) {
        tester(t);
      }
    },
  );
}

/// Pumps a widget with Provider overrides, MaterialApp wrapper, and ContentScaler.
///
/// Use [child] parameter for simple widget tests without routing.
/// Use [router] parameter for tests that require navigation.
Future<void> pumpWithOverrides(
  WidgetTester tester, {
  Widget? child,
  GoRouter? router,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
  List<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  List<Locale>? supportedLocales,
  Locale? locale,
}) async {
  assert(
    (child != null) ^ (router != null),
    'Provide either child or router, but not both',
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      observers: observers,
      child: ContentScaler(
        child: router != null
            ? MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: localizationsDelegates,
                supportedLocales: supportedLocales ?? [const Locale('en')],
                locale: locale,
              )
            : MaterialApp(
                home: child,
                localizationsDelegates: localizationsDelegates,
                supportedLocales: supportedLocales ?? [const Locale('en')],
                locale: locale,
              ),
      ),
    ),
  );

  await tester.pump();
}
