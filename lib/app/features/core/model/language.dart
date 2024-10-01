// SPDX-License-Identifier: ice License 1.0

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
  ukrainian(name: 'Ukrainian', flag: '🇺🇦', isoCode: 'uk');

  const Language({
    required this.name,
    required this.flag,
    required this.isoCode,
  });

  final String name;
  final String flag;
  final String isoCode;
}
