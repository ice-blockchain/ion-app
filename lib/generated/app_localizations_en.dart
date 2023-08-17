import 'app_localizations.dart';

/// The translations for English (`en`).
class I18nEn extends I18n {
  I18nEn([String locale = 'en']) : super(locale);

  @override
  String hello(Object userName) {
    return 'Hello!  $userName';
  }
}
