// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion_content_labeler/ion_content_labeler.dart';

void main() {
  runApp(const MyApp());
}

final _initialInput =
    '''Trump is trying to deport a Columbia Univ. student who has been a permanent resident in the U.S. since she was 7.
Her "crime"?
Attending a protest against the war in Gaza.
No, Mr. President. This is a democracy. You can't exile political dissidents. Not in the United States.''';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController(text: _initialInput);

  String? _normalizedInput;

  String? _language;

  String? _labels;

  @override
  void initState() {
    super.initState();
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
                TextField(controller: _controller),
                ElevatedButton(
                  onPressed: _onButtonPressed,
                  child: Text('run'),
                ),
                SizedBox(height: 10),
                if (_normalizedInput != null) ...[
                  Text('Normalized input is:\n$_normalizedInput'),
                  SizedBox(height: 10)
                ],
                if (_language != null) ...[Text('Language is:\n$_language'), SizedBox(height: 10)],
                if (_labels != null) ...[Text('Categories are:\n$_labels'), SizedBox(height: 10)],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed() {
    setState(() {
      _normalizedInput = null;
      _language = null;
      _labels = null;
    });
    // final input = _controller.text;
    for (var i = 0; i < 1; i++) {
      IonTextLabeler.create(TextLabelerType.language).then((labeler) {
        // labeler.detect(input).then((result) => setState(() {
        //       _language = result.labels.join('\n');
        //       _normalizedInput = result.input;
        //     }));
      });
      IonTextLabeler.create(TextLabelerType.category).then((labeler) {
        // labeler.detect(input).then((result) => setState(() {
        //       _labels = result.labels.join('\n');
        //       _normalizedInput = result.input;
        //     }));
      });
    }
  }
}
