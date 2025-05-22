// Presentation class holds display info
import 'package:flutter/widgets.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion_identity_client/ion_identity.dart';

class ExceptionPresentation {
  const ExceptionPresentation({required this.title, required this.description});

  final String title;
  final String description;
}

class ExceptionPresenter {
  ExceptionPresentation getPresentation(
    BuildContext context,
    Object error, {
    required bool showDebugInfo,
  }) {
    final title = switch (error) {
      final IONIdentityException identityException => identityException.title(context),
      PaymentNoDestinationException() => context.i18n.error_payment_no_destination_title,
      _ => context.i18n.error_general_title,
    };

    final description = switch (error) {
      final PaymentNoDestinationException ex =>
        context.i18n.error_payment_no_destination_description(
          ex.abbreviation,
        ),
      final IONIdentityException identityException => identityException.description(context),
      IONException(code: final int code) => context.i18n.error_general_description(
          context.i18n.error_general_error_code(code),
        ),
      Object _ when showDebugInfo => error.toString(),
      _ => context.i18n.error_general_description('')
    };

    return ExceptionPresentation(
      title: title,
      description: description,
    );
  }
}
