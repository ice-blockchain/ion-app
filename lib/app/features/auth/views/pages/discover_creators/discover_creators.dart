import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/navigation_header/navigation_header.dart';
import 'package:ice/app/components/search/search.dart';
import 'package:ice/app/components/title_description_header/title_description_header.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';
import 'package:ice/app/values/constants.dart';
import 'package:ice/generated/assets.gen.dart';

class DiscoverCreators extends HookConsumerWidget {
  const DiscoverCreators({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<String> searchText = useState('');

    final ValueNotifier<Set<User>> followedCreatorsNotifier =
        useState<Set<User>>(<User>{});
    final Set<User> followedCreators = followedCreatorsNotifier.value;

    final ValueNotifier<List<User>> creatorsNotifier =
        useState<List<User>>(<User>[]);
    useEffect(
      () {
        creatorsNotifier.value = creators;
        return null;
      },
      const <Object?>[],
    );

    final List<User> filteredCreators = searchText.value.isEmpty
        ? creatorsNotifier.value
        : creatorsNotifier.value.where((User creator) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String nameLower = creator.name.toLowerCase();
            final String nicknameLower = creator.nickname.toLowerCase();
            return nameLower.contains(searchLower) ||
                nicknameLower.contains(searchLower);
          }).toList();

    void handleOnTap(User creator, bool isFollowing) {
      final Set<User> newFollowedCreators = Set<User>.from(followedCreators);
      if (isFollowing) {
        newFollowedCreators.remove(creator);
      } else {
        newFollowedCreators.add(creator);
      }
      followedCreatorsNotifier.value = newFollowedCreators;
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: context.theme.appColors.secondaryBackground,
        child: Stack(
          children: <Widget>[
            const NavigationHeader(title: ''),
            Padding(
              padding: const EdgeInsets.only(
                top: navigationHeaderHeight,
                left: kDefaultSidePadding,
                right: kDefaultSidePadding,
              ),
              child: Column(
                children: <Widget>[
                  TitleDescription(
                    title: context.i18n.discover_creators_title,
                    description: context.i18n.discover_creators_description,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Search(
                      onTextChanged: (String value) => searchText.value = value,
                      onClearText: () {
                        searchText.value = '';
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCreators.length,
                      itemBuilder: (BuildContext context, int index) {
                        final User creator = filteredCreators[index];
                        final bool isFollowing =
                            followedCreators.contains(creator);

                        return Container(
                          height: 66,
                          decoration: BoxDecoration(
                            color: context.theme.appColors.tertararyBackground,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultSidePadding,
                          ),
                          child: Row(
                            children: <Widget>[
                              if (creator.imageUrl != null &&
                                  creator.imageUrl!.isNotEmpty)
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    creator.imageUrl!,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          creator.name,
                                          style: context
                                              .theme.appTextThemes.subtitle2
                                              .copyWith(
                                            color: context
                                                .theme.appColors.primaryText,
                                          ),
                                        ),
                                        if (creator.isVerified ?? false)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 4,
                                              top: 2,
                                            ),
                                            child: Image.asset(
                                              Assets.images.verifiedBadge.path,
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      creator.nickname,
                                      style: context.theme.appTextThemes.caption
                                          .copyWith(
                                        color: context
                                            .theme.appColors.tertararyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Button(
                                  onPressed: () => handleOnTap(
                                    creator,
                                    isFollowing,
                                  ),
                                  type: isFollowing
                                      ? ButtonType.primary
                                      : ButtonType.outlined,
                                  tintColor: isFollowing
                                      ? null
                                      : context.theme.appColors.primaryAccent,
                                  label: Text(
                                    isFollowing
                                        ? context.i18n.button_following
                                        : context.i18n.button_follow,
                                    style: context.theme.appTextThemes.caption
                                        .copyWith(
                                      color: isFollowing
                                          ? context.theme.appColors
                                              .secondaryBackground
                                          : context
                                              .theme.appColors.primaryAccent,
                                    ),
                                  ),
                                  mainAxisSize: MainAxisSize.max,
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(77, 28),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
