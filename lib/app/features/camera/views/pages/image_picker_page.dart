// lib/screens/create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/camera/views/components/custom_image_picker.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class ImagePickerPage extends ConsumerWidget {
  const ImagePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: CustomImagePicker(),
    );
  }
}
