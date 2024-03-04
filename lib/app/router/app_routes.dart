import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:ice/app/features/dapps/views/categories/apps/apps.dart';
import 'package:ice/app/features/dapps/views/pages/dapp_details/dapp_details.dart';
import 'package:ice/app/features/dapps/views/pages/dapps.dart';
import 'package:ice/app/features/dapps/views/pages/dapps_list/dapps_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/feed_page.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_page.dart';
import 'package:ice/app/features/user/pages/switch_account_page/switch_account_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/wallet_page.dart';

const IceRoutes<void> initialPage = IceRoutes.splash;

List<IceRoutes<dynamic>> iceRootRoutes = <IceRoutes<dynamic>>[
  IceRoutes.splash,
  IceRoutes.error,
  IceRoutes.intro,
  IceRoutes.home,
  IceRoutes.pullRightMenu,
];

enum IceRoutes<PayloadType> {
  splash(SplashPage.new),
  error(ErrorPage.new),
  intro(
    IntroPage.new,
    type: IceRouteType.bottomSheet,
    children: <IceRoutes<dynamic>>[
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
    children: <IceRoutes<dynamic>>[
      IceRoutes.feed,
      IceRoutes.dapps,
      IceRoutes.chat,
      IceRoutes.wallet,
    ],
  ),
  feed(FeedPage.new),
  dapps(
    DAppsPage.new,
    children: <IceRoutes<dynamic>>[
      IceRoutes.appsList,
      IceRoutes.dappsDetails,
    ],
  ),
  appsList<AppsRouteData>(DAppsList.new),
  pullRightMenu(
    PullRightMenuPage.new,
    type: IceRouteType.bottomSheet,
    children: <IceRoutes<dynamic>>[IceRoutes.switchAccount],
  ),
  switchAccount(SwitchAccountPage.new, type: IceRouteType.bottomSheet),
  chat(ChatPage.new),
  wallet(
    WalletPage.new,
    children: <IceRoutes<dynamic>>[],
  ),
  dappsDetails(
    DAppDetails.new,
    type: IceRouteType.bottomSheet,
  ),
  ;

  const IceRoutes(
    this.builder, {
    this.type = IceRouteType.single,
    this.children,
  });

  final IceRouteType type;
  final List<IceRoutes<dynamic>>? children;
  final IcePageBuilder<PayloadType> builder;

  void go(BuildContext context, {PayloadType? payload}) =>
      context.goNamed(name, extra: payload);

  void push(BuildContext context, {PayloadType? payload}) =>
      context.pushNamed(name, extra: payload);

  void pushReplacement(BuildContext context, {PayloadType? payload}) =>
      context.pushReplacementNamed(name, extra: payload);

  void replace(BuildContext context, {PayloadType? payload}) =>
      context.replaceNamed(name, extra: payload);
}

typedef IcePageBuilder<PayloadType> = IcePage<PayloadType> Function(
  IceRoutes<PayloadType> route,
  dynamic payload,
);

enum IceRouteType {
  single,
  bottomSheet,
  slideFromLeft,
  bottomTabs,
  ;
}
