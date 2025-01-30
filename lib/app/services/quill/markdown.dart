import 'package:flutter_quill/quill_delta.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

final _deltaToMd = DeltaToMarkdown();
final _mdToDelta = MarkdownToDelta(markdownDocument: md.Document(encodeHtml: false));

String deltaToMarkdown(Delta delta) => _deltaToMd.convert(delta);

Delta markdownToDelta(String markdown) => _mdToDelta.convert(markdown);
