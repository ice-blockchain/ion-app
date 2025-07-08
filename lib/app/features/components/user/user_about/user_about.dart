// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/text_editor_preview.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';

class UserAbout extends HookConsumerWidget {
  const UserAbout({
    required this.pubkey,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final String pubkey;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final about = ref.watch(
      userMetadataProvider(pubkey).select((state) => state.valueOrNull?.data.about),
    );

    if (about == null) {
      return const SizedBox.shrink();
    }

    final content = useMemoized(
      () {
        try {
          return Delta.fromJson(jsonDecode(about) as List<dynamic>);
        } on FormatException {
          // Plain-text fallback: wrap the text in a Delta
          return Delta()..insert('$about\n');
        }
      },
      [about],
    );

    return Padding(
      padding: padding,
      child: TextEditorPreview(
        scrollable: false,
        content: content,
      ),
    );
  }
}
