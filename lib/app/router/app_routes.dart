import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/features/auth/views/pages/check_email/check_email.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/discover_creators.dart';
import 'package:ice/app/features/auth/views/pages/enter_code/enter_code.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/intro_page.dart';
import 'package:ice/app/features/auth/views/pages/nostr_auth/nostr_auth.dart';
import 'package:ice/app/features/auth/views/pages/nostr_login/nostr_login.dart';
import 'package:ice/app/features/auth/views/pages/select_country/select_country.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/select_languages.dart';
import 'package:ice/app/features/chat/views/pages/chat_page.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/features/dapps/views/pages/dapps.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_list/dapps_list.dart';
import 'package:ice/app/features/wallet/views/pages/inner_wallet_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page.dart';

const IcePages initialPage = IcePages.splash;

List<IcePages> iceRoots = <IcePages>[
  IcePages.splash,
  IcePages.error,
  IcePages.intro,
  IcePages.home,
];

enum IcePages {
  splash('splash', SplashPage.new),
  error('error', ErrorPage.new),
  intro(
    'intro',
    IntroPage.new,
    type: IcePageType.bottomSheet,
    children: <IcePages>[
      IcePages.auth,
      IcePages.selectCountries,
      IcePages.selectLanguages,
      IcePages.checkEmail,
      IcePages.fillProfile,
      IcePages.discoverCreators,
      IcePages.nostrAuth,
      IcePages.nostrLogin,
      IcePages.enterCode,
    ],
  ),
  auth('auth', AuthPage.new),
  selectCountries('selectCountries', SelectCountries.new),
  selectLanguages('selectLanguages', SelectLanguages.new),
  checkEmail('checkEmail', CheckEmail.new),
  nostrAuth('nostrAuth', NostrAuth.new),
  nostrLogin('nostrLogin', NostrLogin.new),
  enterCode('enterCode', EnterCode.new),
  discoverCreators('discoverCreators', DiscoverCreators.new),
  fillProfile('fillProfile', FillProfile.new),
  home(
    '',
    SizedBox.shrink,
    type: IcePageType.bottomTabs,
    children: <IcePages>[
      IcePages.dapps,
      IcePages.chat,
      IcePages.wallet,
    ],
  ),
  dapps(
    'dapps',
    DAppsPage.new,
    children: <IcePages>[
      IcePages.appsList,
    ],
  ),
  appsList('appsList', DAppsList.new),
  chat('chat', ChatPage.new),
  wallet(
    'wallet',
    WalletPage.new,
    children: <IcePages>[
      IcePages.innerWallet,
    ],
  ),
  innerWallet('innerWallet', InnerWalletPage.new),
  ;

  const IcePages(
    this.name,
    this.builder, {
    this.type = IcePageType.single,
    this.children,
  });

  final String name;
  final IcePageType type;
  final List<IcePages>? children;
  final Widget Function() builder;

  String location(GoRouterState state) => state.namedLocation(name);
}

enum IcePageType {
  single,
  bottomSheet,
  bottomTabs,
  ;
}
