// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

final staging1Config = Platform.isIOS
    ? const FirebaseOptions(
        apiKey: 'AIzaSyCVSlYwxgmES12dNonyBHiApGZ_tGUdJ1o',
        appId: '1:65429012887:ios:4ab3e5dac82c7b278384d2',
        messagingSenderId: '65429012887',
        projectId: 'staging1-1c80c',
      )
    : const FirebaseOptions(
        apiKey: 'AIzaSyDm5X4MLxFjBCxmDF-wHa0D5wfNBeyQhLM',
        appId: '1:65429012887:android:9834c5a443c87a348384d2',
        messagingSenderId: '65429012887',
        projectId: 'staging1-1c80c',
      );

final staging2Config = Platform.isIOS
    ? const FirebaseOptions(
        apiKey: 'AIzaSyCG9e4sJHCLabcN9298E9JRl-eq0DephRc',
        appId: '1:398558954820:ios:53100b166ddddfe8104311',
        messagingSenderId: '398558954820',
        projectId: 'staging2-e4db3',
      )
    : const FirebaseOptions(
        apiKey: 'AIzaSyBV-4j6peNTvregJDj3ndlQGRse9YuX5OU',
        appId: '1:398558954820:android:d3661017aa0ad723104311',
        messagingSenderId: '398558954820',
        projectId: 'staging2-e4db3',
      );
final staging3Config = Platform.isIOS
    ? const FirebaseOptions(
        apiKey: 'AIzaSyBLM-Nmg-YblI5Vl0dzgcKlG8Lob2dlEuk',
        appId: '1:355345238028:ios:ee303913dfee1a19520629',
        messagingSenderId: '355345238028',
        projectId: 'staging3-76387',
      )
    : const FirebaseOptions(
        apiKey: 'AIzaSyBkrbRBsuaPnAwNXyncxdW6kIPgwfwxeM8',
        appId: '1:355345238028:android:3f0bc414da8e2fad520629',
        messagingSenderId: '355345238028',
        projectId: 'staging3-76387',
      );

class IntroPage extends HookConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the intro page video controller here and ensure we pass the same parameters
    // (looping: true) to get the same instance of the already initialized provider from SplashPage.
    // final videoController = ref
    //     .watch(
    //       videoControllerProvider(
    //         VideoControllerParams(
    //           sourcePath: Assets.videos.intro,
    //           looping: true,
    //           autoPlay: true,
    //         ),
    //       ),
    //     )
    //     .value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Fallback white background if the video isn't initialized or an error occurs.
          ColoredBox(
            color: Colors.white,
            child: Center(
              child: Assets.svg.logo.logoCircle.icon(size: 148.0.s),
            ),
          ),
          PositionedDirectional(
            start: 40.0.s,
            end: 40.0.s,
            bottom: MediaQuery.of(context).padding.bottom + 46.0.s,
            child: Animate(
              effects: [
                ScaleEffect(
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                  delay: 2.0.seconds,
                ),
              ],
              child: Column(
                children: [
                  Button(
                    onPressed: () async {
                      try {
                        if (Firebase.apps.isNotEmpty) {
                          await FirebaseMessaging.instance.deleteToken();
                          await Firebase.app().delete();
                        }
                        final res = await Firebase.initializeApp(
                          options: staging1Config,
                        );
                        print(res);
                      } catch (error) {
                        print(error);
                      }
                    },
                    label: const Text('configure staging 1'),
                  ),
                  Button(
                    onPressed: () async {
                      try {
                        if (Firebase.apps.isNotEmpty) {
                          await FirebaseMessaging.instance.deleteToken();
                          await Firebase.app().delete();
                        }
                        final res = await Firebase.initializeApp(
                          options: staging3Config,
                        );
                        print(res);
                      } catch (error) {
                        print(error);
                      }
                    },
                    label: const Text('configure staging 3'),
                  ),
                  Button(
                    onPressed: () async {
                      try {
                        final token = await FirebaseMessaging.instance.getToken();
                        print(token);
                      } catch (error) {
                        print(error);
                      }
                    },
                    label: const Text('get token'),
                  ),
                  Button(
                    onPressed: () async {
                      try {
                        await ref
                            .read(permissionsProvider.notifier)
                            .requestPermission(Permission.notifications);
                      } catch (error) {
                        print(error);
                      }
                    },
                    label: const Text('request permissions'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
