import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class I18nEs extends I18n {
  I18nEs([String locale = 'es']) : super(locale);

  @override
  String hello(Object userName) {
    return 'Ola $userName';
  }
}
