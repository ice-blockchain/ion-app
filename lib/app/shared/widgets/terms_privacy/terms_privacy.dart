import 'package:flutter/material.dart';
import 'package:ice/l10n/I10n.dart';

class TermsPrivacy extends StatelessWidget {
  const TermsPrivacy({super.key});

  Widget handleMatch(String text, int index) {
    return GestureDetector(
      onTap: () {
        /// handle tap
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String text =
        'By continuing, you agree to our [[:link]]Terms of Service[[/:link]] and [[:link]]Privacy Policy[[/:link]]';

    return Text.rich(
      replaceString(
        text,
        tagRegex('link', isSingular: false),
        handleMatch,
      ),
      textAlign: TextAlign.center,
    );
  }
}
