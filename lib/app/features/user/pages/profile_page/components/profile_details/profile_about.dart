// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/browser/browser.dart';
import 'package:ion/app/services/text_parser/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

class ProfileAbout extends HookConsumerWidget {
  const ProfileAbout({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(
      userMetadataProvider(pubkey).select((state) => state.valueOrNull?.data.about),
    );

    if (text == null) {
      return const SizedBox.shrink();
    }

    final textSpanBuilder = useMemoized(
      () => TextSpanBuilder(
        defaultStyle: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
        matcherStyles: TextSpanBuilder.defaultMatchersStyles(context),
      ),
      [text],
    );

    useEffect(
      () {
        return textSpanBuilder.dispose;
      },
      [textSpanBuilder],
    );

    final textSpan = textSpanBuilder.build(
      TextParser.allMatchers().parse(text),
      onTap: (match) {
        if (match.matcher is HashtagMatcher) FeedAdvancedSearchRoute(query: match.text).go(context);
        if (match.matcher is UrlMatcher) openUrlInAppBrowser(match.text);
      },
    );

    return SizedBox(
      width: double.infinity,
      child: Text.rich(
        textSpan,
        textScaler: MediaQuery.textScalerOf(context),
      ),
    );
  }
}
