// SPDX-License-Identifier: ice License 1.0

import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferAlignmentDirectionalRule extends DartLintRule {
  const PreferAlignmentDirectionalRule() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_alignment_directional',
    problemMessage:
        'Prefer AlignmentDirectional values (centerStart, centerEnd, topStart, topEnd, bottomStart, bottomEnd) instead of Alignment values (centerLeft, centerRight, topLeft, topRight, bottomLeft, bottomRight) for RTL support.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    const badAlignments = {
      'centerLeft',
      'centerRight',
      'topLeft',
      'topRight',
      'bottomLeft',
      'bottomRight',
    };
    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.name == 'Alignment' && badAlignments.contains(node.identifier.name)) {
        reporter.atNode(node, _code);
      }
    });
  }
}
