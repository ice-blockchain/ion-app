// SPDX-License-Identifier: ice License 1.0

import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferPositionedDirectionalRule extends DartLintRule {
  const PreferPositionedDirectionalRule() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_positioned_directional',
    problemMessage: 'Prefer PositionedDirectional instead of Positioned for RTL support.',
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
      if (typeName == 'Positioned' && node.constructorName.name == null) {
        reporter.atNode(node, _code);
      }
    });
  }
}
