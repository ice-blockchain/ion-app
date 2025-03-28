// SPDX-License-Identifier: ice License 1.0

import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferBorderDirectionalRule extends DartLintRule {
  const PreferBorderDirectionalRule() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_positioned_directional',
    problemMessage: 'Prefer BorderDirectional instead of Border for RTL support.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final typeName = node.constructorName.type.toSource();
      // Only flag if the constructor is the unnamed (default) constructor.
      if (typeName == 'Border' && node.constructorName.name == null) {
        reporter.atNode(node, _code);
      }
    });
  }
}
