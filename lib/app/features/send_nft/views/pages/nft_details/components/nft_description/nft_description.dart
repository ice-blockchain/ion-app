import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/read_more_text/read_more_text.dart';
import 'package:ice/app/components/rounded_card/card.dart';

class NftDescription extends HookConsumerWidget {
  const NftDescription({
    required this.description,
    super.key,
  });

  final String? description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (description == null) {
      return const SizedBox.shrink();
    }

    return RoundedCard(
      child: ReadMoreText(
        description!,
      ),
    );
  }
}
