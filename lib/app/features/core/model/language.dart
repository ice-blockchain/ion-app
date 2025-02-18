// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';

enum Language {
  english(name: 'English', flag: '🇬🇧', isoCode: 'en'),
  hungarian(name: 'Hungarian - magyar', flag: '🇭🇺', isoCode: 'hu'),
  romanian(name: 'Romanian - română', flag: '🇷🇴', isoCode: 'ro'),
  amharic(name: 'Amharic - አማርኛ', flag: '🇪🇹', isoCode: 'am'),
  arabic(name: 'Arabic - العربية', flag: '🇸🇦', isoCode: 'ar'),
  armenian(name: 'Armenian - հայերեն', flag: '🇦🇲', isoCode: 'hy'),
  bangla(name: 'Bangla - বাংলা', flag: '🇧🇩', isoCode: 'bn'),
  basque(name: 'Basque - euskara', flag: '🇪🇸', isoCode: 'eu'),
  bulgarian(name: 'Bulgarian - български', flag: '🇧🇬', isoCode: 'bg'),
  burmese(name: 'Burmese - မြန်မာ', flag: '🇲🇲', isoCode: 'my'),
  catalan(name: 'Catalan - català', flag: '🇪🇸', isoCode: 'ca'),
  central_kurdish(name: 'Central Kurdish - کوردیی ناوەندی', flag: '🇮🇶', isoCode: 'ckb'),
  chinese(name: 'Chinese - 中文', flag: '🇨🇳', isoCode: 'zh'),
  czech(name: 'Czech - čeština', flag: '🇨🇿', isoCode: 'cs'),
  danish(name: 'Danish - dansk', flag: '🇩🇰', isoCode: 'da'),
  divehi(name: 'Divehi', flag: '🇲🇻', isoCode: 'dv'),
  dutch(name: 'Dutch - Nederlands', flag: '🇳🇱', isoCode: 'nl'),
  esperanto(name: 'Esperanto', flag: '🌍', isoCode: 'eo'),
  estonian(name: 'Estonian - eesti', flag: '🇪🇪', isoCode: 'et'),
  finnish(name: 'Finnish - suomi', flag: '🇫🇮', isoCode: 'fi'),
  french(name: 'French - français', flag: '🇫🇷', isoCode: 'fr'),
  georgian(name: 'Georgian - ქართული', flag: '🇬🇪', isoCode: 'ka'),
  german(name: 'German - Deutsch', flag: '🇩🇪', isoCode: 'de'),
  greek(name: 'Greek - Ελληνικά', flag: '🇬🇷', isoCode: 'el'),
  gujarati(name: 'Gujarati - ગુજરાતી', flag: '🇮🇳', isoCode: 'gu'),
  haitian_creole(name: 'Haitian Creole', flag: '🇭🇹', isoCode: 'ht'),
  hebrew(name: 'Hebrew - עברית', flag: '🇮🇱', isoCode: 'he'),
  hindi(name: 'Hindi - हिन्दी', flag: '🇮🇳', isoCode: 'hi'),
  icelandic(name: 'Icelandic - íslenska', flag: '🇮🇸', isoCode: 'is'),
  indonesian(name: 'Indonesian - Indonesia', flag: '🇮🇩', isoCode: 'id'),
  italian(name: 'Italian - italiano', flag: '🇮🇹', isoCode: 'it'),
  japanese(name: 'Japanese - 日本語', flag: '🇯🇵', isoCode: 'ja'),
  kannada(name: 'Kannada - ಕನ್ನಡ', flag: '🇮🇳', isoCode: 'kn'),
  khmer(name: 'Khmer - ខ្មែរ', flag: '🇰🇭', isoCode: 'km'),
  korean(name: 'Korean - 한국어', flag: '🇰🇷', isoCode: 'ko'),
  lao(name: 'Lao - ລາວ', flag: '🇱🇦', isoCode: 'lo'),
  latvian(name: 'Latvian - latviešu', flag: '🇱🇻', isoCode: 'lv'),
  lithuanian(name: 'Lithuanian - lietuvių', flag: '🇱🇹', isoCode: 'lt'),
  malay(name: 'Malay - Melayu', flag: '🇲🇾', isoCode: 'ms'),
  malayalam(name: 'Malayalam - മലയാളം', flag: '🇮🇳', isoCode: 'ml'),
  marathi(name: 'Marathi - मराठी', flag: '🇮🇳', isoCode: 'mr'),
  nepali(name: 'Nepali - नेपाली', flag: '🇳🇵', isoCode: 'ne'),
  norwegian(name: 'Norwegian - norsk', flag: '🇳🇴', isoCode: 'no'),
  odia(name: 'Odia - ଓଡ଼ିଆ', flag: '🇮🇳', isoCode: 'or'),
  pashto(name: 'Pashto - پښتو', flag: '🇦🇫', isoCode: 'ps'),
  persian(name: 'Persian - فارسی', flag: '🇮🇷', isoCode: 'fa'),
  polish(name: 'Polish - polski', flag: '🇵🇱', isoCode: 'pl'),
  portuguese(name: 'Portuguese - português', flag: '🇵🇹', isoCode: 'pt'),
  punjabi(name: 'Punjabi - ਪੰਜਾਬੀ', flag: '🇮🇳', isoCode: 'pa'),
  russian(name: 'Russian - русский', flag: '🇷🇺', isoCode: 'ru'),
  serbian(name: 'Serbian - српски', flag: '🇷🇸', isoCode: 'sr'),
  sindhi(name: 'Sindhi - سنڌي', flag: '🇵🇰', isoCode: 'sd'),
  sinhala(name: 'Sinhala - සිංහල', flag: '🇱🇰', isoCode: 'si'),
  slovenian(name: 'Slovenian - slovenščina', flag: '🇸🇮', isoCode: 'sl'),
  spanish(name: 'Spanish - español', flag: '🇪🇸', isoCode: 'es'),
  swedish(name: 'Swedish - svenska', flag: '🇸🇪', isoCode: 'sv'),
  tagalog(name: 'Tagalog', flag: '🇵🇭', isoCode: 'tl'),
  tamil(name: 'Tamil - தமிழ்', flag: '🇮🇳', isoCode: 'ta'),
  telugu(name: 'Telugu - తెలుగు', flag: '🇮🇳', isoCode: 'te'),
  thai(name: 'Thai - ไทย', flag: '🇹🇭', isoCode: 'th'),
  tibetan(name: 'Tibetan - བོད་སྐད་', flag: '🇨🇳', isoCode: 'bo'),
  turkish(name: 'Turkish - Türkçe', flag: '🇹🇷', isoCode: 'tr'),
  ukrainian(name: 'Ukrainian - українська', flag: '🇺🇦', isoCode: 'uk'),
  urdu(name: 'Urdu - اردو', flag: '🇵🇰', isoCode: 'ur'),
  uyghur(name: 'Uyghur - ئۇيغۇرچە', flag: '🇨🇳', isoCode: 'ug'),
  vietnamese(name: 'Vietnamese - Tiếng Việt', flag: '🇻🇳', isoCode: 'vi'),
  welsh(name: 'Welsh - Cymraeg', flag: '🏴', isoCode: 'cy'),
  other(name: 'Other', flag: '🌍', isoCode: 'other');

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
