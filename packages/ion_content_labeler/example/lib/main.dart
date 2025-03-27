// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion_content_labeler/ion_content_labeler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _input;

  String? _normalizedInput;

  String? _language;

  String? _category;

  @override
  void initState() {
    super.initState();
    final labeler = IonTextLabeler();
    _input =
        '''Trump is trying to deport a Columbia Univ. student who has been a permanent resident in the U.S. since she was 7.
Her "crime"?
Attending a protest against the war in Gaza.
No, Mr. President. This is a democracy. You can't exile political dissidents. Not in the United States.''';
    labeler.detectTextLanguage(_input!).then((result) => setState(() {
          _language = result.labels.first;
          _normalizedInput = result.input;
        }));
    labeler.detectTextCategory(_input!).then((result) => setState(() {
          _category = result.labels.first;
          _normalizedInput = result.input;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ion Content Labeler Example'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Input text is:\n$_input'),
                SizedBox(height: 10),
                if (_normalizedInput != null) ...[
                  Text('Normalized input is:\n$_normalizedInput'),
                  SizedBox(height: 10)
                ],
                if (_language != null) ...[Text('Language is:\n$_language'), SizedBox(height: 10)],
                if (_category != null) ...[Text('Category is:\n$_category'), SizedBox(height: 10)],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
