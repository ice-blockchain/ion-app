// SPDX-License-Identifier: ice License 1.0

import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferBorderRadiusDirectionalRule extends DartLintRule {
  const PreferBorderRadiusDirectionalRule() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_border_radius_directional',
    problemMessage:
        'Prefer BorderRadiusDirectional.only instead of BorderRadius.only for RTL support.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final typeName = node.constructorName.type.toSource();
      final constructorName = node.constructorName.name?.name;
      if (typeName == 'BorderRadius' && constructorName == 'only') {
        reporter.atNode(
          node,
          _code,
        );
      }
    });
  }
}
