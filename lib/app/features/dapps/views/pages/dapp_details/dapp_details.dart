import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/read_more_text/read_more_text.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/providers/dapps_provider.dart';
import 'package:ice/app/features/dapps/views/components/grid_item/grid_item.dart';
import 'package:ice/app/features/dapps/views/pages/dapp_details/components/dapp_details_info_block/dapp_details_info_block.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/services/browser/browser.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class DAppDetails extends ConsumerWidget {
  DAppDetails({
    required this.dappId,
    super.key,
  });

  final int dappId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(dappByIdProvider(dappId: dappId));
    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.s),
              child: NavigationAppBar.screen(
                title: Text(item.title),
                showBackButton: false,
                actions: const [
                  NavigationCloseButton(),
                ],
              ),
            ),
            ScreenSideOffset.small(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10.0.s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                            if (item.link != null) {
                              await openUrl(item.link!);
                            }
                          },
                          child: Text(
                            item.link!,
                            style: context.theme.appTextThemes.caption2.copyWith(
                              color: context.theme.appColors.primaryAccent,
                            ),
                          ),
                        ),
                      ),
                    if (item.value != null)
                      DappDetailsInfoBlock(
                        title: Text(
                          context.i18n.dapp_details_tips,
                          style: context.theme.appTextThemes.caption2.copyWith(
                            color: context.theme.appColors.secondaryText,
                          ),
                        ),
                        value: Text(
                          formatDouble(item.value!),
                          style: context.theme.appTextThemes.subtitle.copyWith(
                            color: context.theme.appColors.primaryText,
                          ),
                        ),
                        iconPath: Assets.images.icons.iconButtonIceStroke.path,
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: DappDetailsInfoBlock(
                            title: Text(
                              context.i18n.dapp_details_tips_games,
                              style: context.theme.appTextThemes.caption2.copyWith(
                                color: context.theme.appColors.secondaryText,
                              ),
                            ),
                            value: Text(
                              '№1',
                              style: context.theme.appTextThemes.title.copyWith(
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
                              context.i18n.dapp_details_tips_global_rank,
                              style: context.theme.appTextThemes.caption2.copyWith(
                                color: context.theme.appColors.secondaryText,
                              ),
                            ),
                            value: Text(
                              '№3',
                              style: context.theme.appTextThemes.title.copyWith(
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
            )
          ],
        ),
      ),
    );
  }
}
