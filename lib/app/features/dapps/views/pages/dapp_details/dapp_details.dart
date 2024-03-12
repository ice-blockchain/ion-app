import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/read_more_text/read_more_text.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/components/grid_item/grid_item.dart';
import 'package:ice/app/features/dapps/views/pages/dapp_details/components/dapp_details_info_block/dapp_details_info_block.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_featured.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';

class DAppDetails extends IceSimplePage {
  DAppDetails(super._route, super.payload);

  final DAppItem item = mockedFeatured[2]; //TODO: get from params or provider

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: item.title,
        showBackButton: false,
        actions: <Widget>[
          IconButton(
            icon: Assets.images.icons.iconSheetClose.icon(
              size: NavigationAppBar.actionButtonSide,
              color: context.theme.appColors.primaryText,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      body: SizedBox(
        child: ScreenSideOffset.small(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 10.0.s),
                  child: Column(
                    children: <Widget>[
                      if (item.backgroundImage != null)
                        AspectRatio(
                          aspectRatio: 343 / 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0.s),
                            child: Image.asset(
                              item.backgroundImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0.s, bottom: 18.0.s),
                        child: GridItem(
                          item: item,
                          showIsFavourite: true,
                        ),
                      ),
                      if (item.fullDescription != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.0.s),
                          child: ReadMoreText(
                            item.fullDescription!,
                          ),
                        ),
                      if (item.link != null)
                        DappDetailsInfoBlock(
                          iconPath: Assets.images.icons.iconWalletLink.path,
                          value: InkWell(
                            onTap: () async {
                              final Uri uri = Uri(path: item.link);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                            child: Text(
                              item.link!,
                              style:
                                  context.theme.appTextThemes.caption2.copyWith(
                                color: context.theme.appColors.primaryAccent,
                              ),
                            ),
                          ),
                        ),
                      if (item.value != null)
                        DappDetailsInfoBlock(
                          title: Text(
                            'Tips',
                            style:
                                context.theme.appTextThemes.caption2.copyWith(
                              color: context.theme.appColors.secondaryText,
                            ),
                          ),
                          value: Text(
                            formatDouble(item.value!),
                            style:
                                context.theme.appTextThemes.subtitle.copyWith(
                              color: context.theme.appColors.primaryText,
                            ),
                          ),
                          iconPath:
                              Assets.images.icons.iconButtonIceStroke.path,
                        ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DappDetailsInfoBlock(
                              title: Text(
                                'Games',
                                style: context.theme.appTextThemes.caption2
                                    .copyWith(
                                  color: context.theme.appColors.secondaryText,
                                ),
                              ),
                              value: Text(
                                '№1',
                                style:
                                    context.theme.appTextThemes.title.copyWith(
                                  color: context.theme.appColors.primaryText,
                                ),
                              ),
                              iconPath: Assets.images.icons.iconDappGames.path,
                            ),
                          ),
                          SizedBox(
                            width: 10.0.s,
                          ),
                          Expanded(
                            child: DappDetailsInfoBlock(
                              title: Text(
                                'Global Rank',
                                style: context.theme.appTextThemes.caption2
                                    .copyWith(
                                  color: context.theme.appColors.secondaryText,
                                ),
                              ),
                              value: Text(
                                '№3',
                                style:
                                    context.theme.appTextThemes.title.copyWith(
                                  color: context.theme.appColors.primaryText,
                                ),
                              ),
                              iconPath: Assets.images.icons.iconDappGames.path,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0.s, bottom: 56.0.s),
                        child: Button(
                          label: Text(
                            context.i18n.dapp_details_launch_dapp_button_title,
                          ),
                          onPressed: () {},
                          mainAxisSize: MainAxisSize.max,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
