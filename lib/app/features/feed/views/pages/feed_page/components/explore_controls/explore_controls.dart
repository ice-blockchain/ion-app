import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/components/search_input/search_input.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/explore_controls/hooks/use_explore_controls_state.dart';
import 'package:ice/generated/assets.gen.dart';

class ExploreControls extends HookWidget {
  const ExploreControls({
    super.key,
    required this.pageScrollController,
  });

  final ScrollController pageScrollController;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ExploreControlsState> state =
        useExploreControlsState(pageScrollController);

    return ScreenSideOffset.small(
      child: Padding(
        padding: EdgeInsets.only(top: 9.0.s),
        child: switch (state.value) {
          ExploreControlsState.initial => _InitialState(
              onFiltersPressed: () {
                state.value = ExploreControlsState.filters;
              },
            ),
          ExploreControlsState.filters => const _FiltersState(),
        },
      ),
    );
  }
}

class _InitialState extends StatelessWidget {
  const _InitialState({
    required this.onFiltersPressed,
  });

  final VoidCallback onFiltersPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SearchInput(
            onTextChanged: (String st) {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0.s),
          child: _ExploreButton(
            onPressed: () {},
            iconPath: Assets.images.icons.iconHomeNotification.path,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0.s),
          child: _ExploreButton(
            onPressed: onFiltersPressed,
            iconPath: Assets.images.icons.iconHeaderMenu.path,
          ),
        ),
      ],
    );
  }
}

class _FiltersState extends StatelessWidget {
  const _FiltersState();

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      fallbackHeight: 40.0.s,
    );
  }
}

class _ExploreButton extends StatelessWidget {
  const _ExploreButton({
    required this.iconPath,
    required this.onPressed,
  });

  final String iconPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button.icon(
      tintColor: context.theme.appColors.onTerararyFill,
      size: 40.0.s,
      onPressed: onPressed,
      icon: ButtonIcon(
        iconPath,
        color: context.theme.appColors.primaryText,
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: context.theme.appColors.tertararyBackground,
      ),
    );
  }
}
