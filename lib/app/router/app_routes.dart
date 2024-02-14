import 'package:ice/app/components/template/ice_page.dart';
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

const IceRoutes initialPage = IceRoutes.splash;

List<IceRoutes> iceRootRoutes = <IceRoutes>[
  IceRoutes.splash,
  IceRoutes.error,
  IceRoutes.intro,
  IceRoutes.home,
];

enum IceRoutes {
  splash(SplashPage.new),
  error(ErrorPage.new),
  intro(
    IntroPage.new,
    type: IceRouteType.bottomSheet,
    children: <IceRoutes>[
      IceRoutes.auth,
      IceRoutes.selectCountries,
      IceRoutes.selectLanguages,
      IceRoutes.checkEmail,
      IceRoutes.fillProfile,
      IceRoutes.discoverCreators,
      IceRoutes.nostrAuth,
      IceRoutes.nostrLogin,
      IceRoutes.enterCode,
    ],
  ),
  auth(AuthPage.new),
  selectCountries(SelectCountries.new),
  selectLanguages(SelectLanguages.new),
  checkEmail(CheckEmail.new),
  nostrAuth(NostrAuth.new),
  nostrLogin(NostrLogin.new),
  enterCode(EnterCode.new),
  discoverCreators(DiscoverCreators.new),
  fillProfile(FillProfile.new),
  home(
    AbsentPage.new,
    type: IceRouteType.bottomTabs,
    children: <IceRoutes>[
      IceRoutes.dapps,
      IceRoutes.chat,
      IceRoutes.wallet,
    ],
  ),
  dapps(
    DAppsPage.new,
    children: <IceRoutes>[
      IceRoutes.appsList,
    ],
  ),
  appsList(DAppsList.new),
  chat(ChatPage.new),
  wallet(
    WalletPage.new,
    children: <IceRoutes>[
      IceRoutes.innerWallet,
    ],
  ),
  innerWallet(InnerWalletPage.new),
  ;

  const IceRoutes(
    this.builder, {
    this.type = IceRouteType.single,
    this.children,
  });

  final IceRouteType type;
  final List<IceRoutes>? children;
  final IcePageBuilder builder;
}

typedef IcePageBuilder<PayloadType, PageType extends IcePage<PayloadType>>
    = PageType Function(
  IceRoutes route,
  PayloadType? payload,
);

enum IceRouteType {
  single,
  bottomSheet,
  bottomTabs,
  ;
}
