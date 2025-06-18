// SPDX-License-Identifier: ice License 1.0

// Presentation class holds display info
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exception_presenter_provider.c.g.dart';

@Riverpod(keepAlive: true)
ExceptionPresenter exceptionPresenter(Ref ref) {
  return ExceptionPresenter(
    showDebugInfo: ref.watch(envProvider.notifier).get<bool>(EnvVariable.SHOW_DEBUG_INFO),
  );
}

class ExceptionPresentation {
  const ExceptionPresentation({
    required this.title,
    required this.description,
    required this.iconPath,
  });

  final String title;
  final String description;
  final String iconPath;
}

class ExceptionPresenter {
  ExceptionPresenter({required this.showDebugInfo});

  final bool showDebugInfo;

  ExceptionPresentation getPresentation(BuildContext context, Object error) {
    return ExceptionPresentation(
      title: _getTitle(context, error),
      description: _getDescription(context, error),
      iconPath: _getIconPath(error),
    );
  }

  String _getTitle(BuildContext context, Object error) {
    final locale = context.i18n;
    return switch (error) {
      PaymentNoDestinationException() => locale.error_payment_no_destination_title,
      final IONIdentityException identityException => identityException.title(context),
      _ => context.i18n.error_general_title,
    };
  }

  String _getDescription(BuildContext context, Object error) {
    final locale = context.i18n;
    return switch (error) {
      final PaymentNoDestinationException ex =>
        locale.error_payment_no_destination_description(ex.abbreviation),
      final IONIdentityException identityException => identityException.description(context),
      Object _ when showDebugInfo => error.toString(),
      IONException(code: final int code) =>
        context.i18n.error_general_description(context.i18n.error_general_error_code(code)),
      _ => context.i18n.error_general_description('')
    };
  }

  String _getIconPath(Object error) => switch (error) {
        _ => Assets.svgActionWalletKeyserror,
      };
}
