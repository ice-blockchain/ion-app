// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:ion/app/features/video/views/components/video_post_text.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';

// TODO: decompose this widget when video swiper will be implemented
class VideoPage extends HookConsumerWidget {
  const VideoPage(this.eventReference, {super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postResult = ref.watch(nostrEntityProvider(eventReference: eventReference));
    final isMuted = ref.watch(globalMuteProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.theme.appColors.primaryText,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.theme.appColors.primaryText,
        body: postResult.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text(error.toString()),
          ),
          data: (nostrEntity) {
            if (nostrEntity == null || nostrEntity is! PostEntity) {
              return Center(
                child: Text(context.i18n.video_not_found),
              );
            }

            final postEntity = nostrEntity;

            final videoPath = postEntity.data.primaryMedia?.url;
            if (videoPath == null || videoPath.isEmpty) {
              return Text(context.i18n.video_not_found);
            }

            final playerController = ref.watch(
              videoControllerProvider(
                videoPath,
                autoPlay: true,
              ),
            );

            if (!playerController.value.isInitialized) {
              return const CenteredLoadingIndicator();
            }

            useOnInit(
              () => playerController.setVolume(isMuted ? 0 : 1),
              [isMuted],
            );

            return Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: playerController.value.aspectRatio,
                    child: VideoPlayer(playerController),
                  ),
                ),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.s),
                        child: GestureDetector(
                          onTap: context.pop,
                          child: Container(
                            height: 36.0.s,
                            width: 36.0.s,
                            decoration: BoxDecoration(
                              color: context.theme.appColors.primaryText.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Assets.svg.iconBackArrow.icon(
                                color: context.theme.appColors.secondaryBackground,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 6.0.s, left: 16.0.s, right: 16.0.s),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: const [0.0, 0.55, 1.0],
                                colors: [
                                  context.theme.appColors.primaryText.withOpacity(1),
                                  context.theme.appColors.primaryText.withOpacity(0.71),
                                  context.theme.appColors.primaryText.withOpacity(0),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TODO: fix route issue, route to another route tree
                                UserInfo(
                                  pubkey: eventReference.pubkey,
                                  trailing: UserInfoMenu(
                                    pubkey: eventReference.pubkey,
                                    iconColor: context.theme.appColors.secondaryBackground,
                                  ),
                                  textStyle: TextStyle(
                                    color: context.theme.appColors.secondaryBackground,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0.s,
                                ),
                                VideoTextPost(
                                  postEntity: postEntity,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 48.0.s,
                            color: context.theme.appColors.primaryText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
