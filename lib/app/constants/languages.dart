import 'package:freezed_annotation/freezed_annotation.dart';

part 'languages.freezed.dart';

@freezed
class Language with _$Language {
  const factory Language({
    required String name,
    required String flag,
    required String isoCode,
  }) = _Language;
}

const List<Language> languages = [
  Language(name: 'English', flag: '🇬🇧', isoCode: 'en'),
  Language(name: 'Spanish', flag: '🇪🇸', isoCode: 'es'),
  Language(name: 'French', flag: '🇫🇷', isoCode: 'fr'),
  Language(name: 'German', flag: '🇩🇪', isoCode: 'de'),
  Language(name: 'Chinese', flag: '🇨🇳', isoCode: 'zh'),
  Language(name: 'Japanese', flag: '🇯🇵', isoCode: 'ja'),
  Language(name: 'Portuguese', flag: '🇵🇹', isoCode: 'pt'),
  Language(name: 'Russian', flag: '🇷🇺', isoCode: 'ru'),
  Language(name: 'Italian', flag: '🇮🇹', isoCode: 'it'),
  Language(name: 'Korean', flag: '🇰🇷', isoCode: 'ko'),
  Language(name: 'Arabic', flag: '🇸🇦', isoCode: 'ar'),
  Language(name: 'Hindi', flag: '🇮🇳', isoCode: 'hi'),
  Language(name: 'Turkish', flag: '🇹🇷', isoCode: 'tr'),
  Language(name: 'Dutch', flag: '🇳🇱', isoCode: 'nl'),
  Language(name: 'Swedish', flag: '🇸🇪', isoCode: 'sv'),
  Language(name: 'Greek', flag: '🇬🇷', isoCode: 'el'),
  Language(name: 'Polish', flag: '🇵🇱', isoCode: 'pl'),
  Language(name: 'Thai', flag: '🇹🇭', isoCode: 'th'),
  Language(name: 'Vietnamese', flag: '🇻🇳', isoCode: 'vi'),
  Language(name: 'Hebrew', flag: '🇮🇱', isoCode: 'he'),
  Language(name: 'Ukrainian', flag: '🇺🇦', isoCode: 'uk'),
];
