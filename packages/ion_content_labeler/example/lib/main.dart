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

  String? _language;

  String? _category;

  @override
  void initState() {
    super.initState();
    _input =
        'Advancements in artificial intelligence are revolutionizing industries by enabling faster data analysis and smarter decision-making.';
    detectTextLanguage(_input!).then((language) => setState(() {
          _language = language;
        }));
    detectTextCategory(_input!).then((category) => setState(() {
          _category = category;
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
              children: [
                Text('Input text is:\n$_input'),
                SizedBox(height: 10),
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
