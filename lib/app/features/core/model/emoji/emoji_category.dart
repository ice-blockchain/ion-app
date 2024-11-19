import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

enum EmojiCategory {
  smileysPeople,
  animalsNature,
  foodAndDrink,
  activities,
  travelAndPlaces,
  objects,
  symbols,
  flags;

  String getTitle(BuildContext context) {
    return switch (this) {
      EmojiCategory.smileysPeople => context.i18n.emoji_category_smileys_people,
      EmojiCategory.animalsNature => context.i18n.emoji_category_animals_nature,
      EmojiCategory.foodAndDrink => context.i18n.emoji_category_food_drink,
      EmojiCategory.activities => context.i18n.emoji_category_activities,
      EmojiCategory.travelAndPlaces => context.i18n.emoji_category_travel_places,
      EmojiCategory.objects => context.i18n.emoji_category_objects,
      EmojiCategory.symbols => context.i18n.emoji_category_symbols,
      EmojiCategory.flags => context.i18n.emoji_category_flags,
    };
  }

  static EmojiCategory fromSlug(String slug) {
    return switch (slug) {
      'smileys_people' => EmojiCategory.smileysPeople,
      'animals_nature' => EmojiCategory.animalsNature,
      'food_drink' => EmojiCategory.foodAndDrink,
      'activities' => EmojiCategory.activities,
      'travel_places' => EmojiCategory.travelAndPlaces,
      'objects' => EmojiCategory.objects,
      'symbols' => EmojiCategory.symbols,
      'flags' => EmojiCategory.flags,
      _ => throw Exception('Invalid emoji category slug: $slug'),
    };
  }
}
