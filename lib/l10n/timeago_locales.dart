// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/data/models/language.dart';
import 'package:ion/l10n/short_timeago_messages_adapter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';

final Map<String, LookupMessages> fullLocalesMap = {
  'ar': ArMessages(),
  'az': AzMessages(),
  'bn': BnMessages(),
  'ca': CaMessages(),
  'cs': CsMessages(),
  'da': DaMessages(),
  'de': DeMessages(),
  'dv': DvMessages(),
  'en': EnMessages(),
  'es': EsMessages(),
  'et': EtMessages(),
  'fa': FaMessages(),
  'fi': FiMessages(),
  'fr': FrMessages(),
  'gr': GrMessages(),
  'he': HeMessages(),
  'hi': HiMessages(),
  'hu': HuMessages(),
  'id': IdMessages(),
  'it': ItMessages(),
  'ja': JaMessages(),
  'km': KmMessages(),
  'ko': KoMessages(),
  'ku': KuMessages(),
  'mn': MnMessages(),
  'ms_MY': MsMyMessages(),
  'nb_NO': NbNoMessages(),
  'nl': NlMessages(),
  'nn_NO': NnNoMessages(),
  'pl': PlMessages(),
  'pt_BR': PtBrMessages(),
  'ro': RoMessages(),
  'ru': RuMessages(),
  'rw': RwMessages(),
  'sv': SvMessages(),
  'ta': TaMessages(),
  'th': ThMessages(),
  'tk': TkMessages(),
  'tr': TrMessages(),
  'uk': UkMessages(),
  'ur': UrMessages(),
  'vi': ViMessages(),
  'zh_CN': ZhCnMessages(),
  'zh': ZhMessages(),
};

// Some languages may not have official short sets
// of locales (if no short version is defined, re-use full)
final Map<String, LookupMessages> shortLocalesMap = {
  'ar_short': ArShortMessages(),
  'az_short': AzShortMessages(),
  'bn_short': BnShortMessages(),
  'ca_short': CaShortMessages(),
  'cs_short': CsShortMessages(),
  'da_short': DaShortMessages(),
  'de_short': DeShortMessages(),
  'dv_short': DvShortMessages(),
  'en_short': EnShortMessages(),
  'es_short': EsShortMessages(),
  'et_short': EtShortMessages(),
  'fa_short': FaMessages(),
  'fi_short': FiShortMessages(),
  'fr_short': FrShortMessages(),
  'gr_short': GrShortMessages(),
  'he_short': HeShortMessages(),
  'hi_short': HiShortMessages(),
  'hu_short': HuShortMessages(),
  'id_short': IdShortMessages(),
  'it_short': ItShortMessages(),
  'ja_short': JaMessages(),
  'km_short': KmShortMessages(),
  'ko_short': KoMessages(),
  'ku_short': KuShortMessages(),
  'mn_short': MnShortMessages(),
  'ms_MY_short': MsMyShortMessages(),
  'nb_NO_short': NbNoShortMessages(),
  'nl_short': NlShortMessages(),
  'nn_NO_short': NnNoShortMessages(),
  'pl_short': PlMessages(),
  'pt_BR_short': PtBrShortMessages(),
  'ro_short': RoShortMessages(),
  'ru_short': RuShortMessages(),
  'rw_short': RwShortMessages(),
  'sv_short': SvShortMessages(),
  'ta_short': TaMessages(),
  'th_short': ThShortMessages(),
  'tk_short': TkMessages(),
  'tr_short': TrShortMessages(),
  'uk_short': UkShortMessages(),
  'ur_short': UrMessages(),
  'vi_short': ViShortMessages(),
  'zh_short': ZhMessages(),
  'zh_CN_short': ZhCnMessages(),
};

/// Maps the isoCode from [Language] to the corresponding timeago locale key.
String _mapIsoCode(String isoCode) {
  return switch (isoCode.toLowerCase()) {
    'pt' => 'pt_BR',
    'zh' => 'zh_CN',
    'el' => 'gr',
    _ => isoCode.toLowerCase()
  };
}

/// Registers timeago locales (both full and short) for languages defined in the [Language] enum.
/// If a short locale is missing, it falls back to `en_short` for consistent behavior.
void registerTimeagoLocalesForEnum() {
  for (final lang in Language.values) {
    // Map the isoCode to a timeago-compatible locale key.
    final isoMapped = _mapIsoCode(lang.isoCode);

    final fullLocale = fullLocalesMap[isoMapped];

    if (fullLocale != null) {
      timeago.setLocaleMessages(isoMapped, fullLocale);
    }

    final shortKey = '${isoMapped}_short';
    final shortLocale = shortLocalesMap[shortKey];

    if (shortLocale != null) {
      final overridden = ShortTimeagoMessagesAdapter(shortLocale);

      timeago.setLocaleMessages(shortKey, overridden);
    } else {
      final fallbackShortLocale = shortLocalesMap['en_short'];
      if (fallbackShortLocale != null) {
        timeago.setLocaleMessages(shortKey, fallbackShortLocale);
      }
    }
  }
}
