// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_span_builder/hooks/use_text_span_builder.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

class UserAbout extends HookConsumerWidget {
  const UserAbout({
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

    return Text.rich(
      useTextSpanBuilder(context).build(
        TextParser.allMatchers().parse(text),
        onTap: (match) => TextSpanBuilder.defaultOnTap(context, match: match),
      ),
      textScaler: MediaQuery.textScalerOf(context),
    );
  }
}
