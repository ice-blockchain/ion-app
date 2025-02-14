// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';

enum Language {
  english(name: 'English', flag: '🇬🇧', isoCode: 'en'),
  spanish(name: 'Spanish', flag: '🇪🇸', isoCode: 'es'),
  french(name: 'French', flag: '🇫🇷', isoCode: 'fr'),
  german(name: 'German', flag: '🇩🇪', isoCode: 'de'),
  chinese(name: 'Chinese', flag: '🇨🇳', isoCode: 'zh'),
  japanese(name: 'Japanese', flag: '🇯🇵', isoCode: 'ja'),
  portuguese(name: 'Portuguese', flag: '🇵🇹', isoCode: 'pt'),
  russian(name: 'Russian', flag: '🇷🇺', isoCode: 'ru'),
  italian(name: 'Italian', flag: '🇮🇹', isoCode: 'it'),
  korean(name: 'Korean', flag: '🇰🇷', isoCode: 'ko'),
  arabic(name: 'Arabic', flag: '🇸🇦', isoCode: 'ar'),
  hindi(name: 'Hindi', flag: '🇮🇳', isoCode: 'hi'),
  turkish(name: 'Turkish', flag: '🇹🇷', isoCode: 'tr'),
  dutch(name: 'Dutch', flag: '🇳🇱', isoCode: 'nl'),
  swedish(name: 'Swedish', flag: '🇸🇪', isoCode: 'sv'),
  greek(name: 'Greek', flag: '🇬🇷', isoCode: 'el'),
  polish(name: 'Polish', flag: '🇵🇱', isoCode: 'pl'),
  thai(name: 'Thai', flag: '🇹🇭', isoCode: 'th'),
  vietnamese(name: 'Vietnamese', flag: '🇻🇳', isoCode: 'vi'),
  hebrew(name: 'Hebrew', flag: '🇮🇱', isoCode: 'he'),
  ukrainian(name: 'Ukrainian', flag: '🇺🇦', isoCode: 'uk'),
  finnish(name: 'Finnish', flag: '🇫🇮', isoCode: 'fi'),
  norwegian(name: 'Norwegian', flag: '🇳🇴', isoCode: 'no'),
  danish(name: 'Danish', flag: '🇩🇰', isoCode: 'da'),
  czech(name: 'Czech', flag: '🇨🇿', isoCode: 'cs'),
  hungarian(name: 'Hungarian', flag: '🇭🇺', isoCode: 'hu'),
  romanian(name: 'Romanian', flag: '🇷🇴', isoCode: 'ro'),
  bulgarian(name: 'Bulgarian', flag: '🇧🇬', isoCode: 'bg'),
  catalan(name: 'Catalan', flag: '🇦🇩', isoCode: 'ca'),
  filipino(name: 'Filipino', flag: '🇵🇭', isoCode: 'fil'),
  indonesian(name: 'Indonesian', flag: '🇮🇩', isoCode: 'id'),
  malay(name: 'Malay', flag: '🇲🇾', isoCode: 'ms'),
  swahili(name: 'Swahili', flag: '🇰🇪', isoCode: 'sw'),
  afrikaans(name: 'Afrikaans', flag: '🇿🇦', isoCode: 'af'),
  albanian(name: 'Albanian', flag: '🇦🇱', isoCode: 'sq'),
  armenian(name: 'Armenian', flag: '🇦🇲', isoCode: 'hy'),
  azerbaijani(name: 'Azerbaijani', flag: '🇦🇿', isoCode: 'az'),
  basque(name: 'Basque', flag: '🇪🇸', isoCode: 'eu'),
  belarusian(name: 'Belarusian', flag: '🇧🇾', isoCode: 'be'),
  bengali(name: 'Bengali', flag: '🇧🇩', isoCode: 'bn'),
  bosnian(name: 'Bosnian', flag: '🇧🇦', isoCode: 'bs'),
  croatian(name: 'Croatian', flag: '🇭🇷', isoCode: 'hr'),
  esperanto(name: 'Esperanto', flag: '🌍', isoCode: 'eo'),
  estonian(name: 'Estonian', flag: '🇪🇪', isoCode: 'et'),
  georgian(name: 'Georgian', flag: '🇬🇪', isoCode: 'ka'),
  icelandic(name: 'Icelandic', flag: '🇮🇸', isoCode: 'is'),
  irish(name: 'Irish', flag: '🇮🇪', isoCode: 'ga'),
  kazakh(name: 'Kazakh', flag: '🇰🇿', isoCode: 'kk'),
  latvian(name: 'Latvian', flag: '🇱🇻', isoCode: 'lv'),
  lithuanian(name: 'Lithuanian', flag: '🇱🇹', isoCode: 'lt'),
  macedonian(name: 'Macedonian', flag: '🇲🇰', isoCode: 'mk'),
  malagasy(name: 'Malagasy', flag: '🇲🇬', isoCode: 'mg'),
  maltese(name: 'Maltese', flag: '🇲🇹', isoCode: 'mt'),
  mongolian(name: 'Mongolian', flag: '🇲🇳', isoCode: 'mn'),
  nepali(name: 'Nepali', flag: '🇳🇵', isoCode: 'ne'),
  persian(name: 'Persian', flag: '🇮🇷', isoCode: 'fa'),
  serbian(name: 'Serbian', flag: '🇷🇸', isoCode: 'sr'),
  slovak(name: 'Slovak', flag: '🇸🇰', isoCode: 'sk'),
  slovenian(name: 'Slovenian', flag: '🇸🇮', isoCode: 'sl'),
  somali(name: 'Somali', flag: '🇸🇴', isoCode: 'so'),
  tamil(name: 'Tamil', flag: '🇮🇳', isoCode: 'ta'),
  telugu(name: 'Telugu', flag: '🇮🇳', isoCode: 'te'),
  urdu(name: 'Urdu', flag: '🇵🇰', isoCode: 'ur'),
  welsh(name: 'Welsh', flag: '🏴', isoCode: 'cy'),
  zulu(name: 'Zulu', flag: '🇿🇦', isoCode: 'zu');

  const Language({
    required this.name,
    required this.flag,
    required this.isoCode,
  });

  final String name;
  final String flag;
  final String isoCode;

  static Language? fromIsoCode(String isoCode) {
    return Language.values.firstWhereOrNull(
      (lang) => isoCode.toLowerCase() == lang.isoCode.toLowerCase(),
    );
  }
}
