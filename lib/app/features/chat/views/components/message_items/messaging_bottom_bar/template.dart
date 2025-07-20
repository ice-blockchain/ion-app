import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SampleApp()));
}

class SampleApp extends StatefulWidget {
  const SampleApp({super.key});

  @override
  State<SampleApp> createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp> {
  final FocusNode textFieldFocusNode = FocusNode();
  bool showMenu = false;
  double cachePaddding = 0;

  void onDefaultMode() {
    setState(() {
      showMenu = false;
    });
    textFieldFocusNode.requestFocus();

    Future<void>.delayed(const Duration(seconds: 1)).then((_) {
      if (!showMenu) cachePaddding = 0;
    });
  }

  void menuMode() {
    final padding = max(
      MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).viewPadding.bottom,
      0,
    ).toDouble();

    textFieldFocusNode.unfocus();

    setState(() {
      cachePaddding = padding;
      showMenu = true;
    });
  }

  void onTapOutside() {
    textFieldFocusNode.unfocus();
    setState(() {
      cachePaddding = 0;
      showMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = max(
      MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).viewPadding.bottom,
      0,
    ).toDouble();

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (_, i) => ListTile(
                        title: Text('$i'),
                        onTap: onTapOutside,
                      ),
                      reverse: true,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: menuMode,
                        icon: const Icon(Icons.attach_file),
                      ),
                      IconButton(
                        onPressed: onDefaultMode,
                        icon: const Icon(Icons.keyboard),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a message',
                          ),
                          focusNode: textFieldFocusNode,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: cachePaddding > 0
                        ? cachePaddding
                        : padding > 0
                            ? padding
                            : showMenu
                                ? 264
                                : 0,
                    color: Colors.blue,
                    child: const Text('MENU'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
