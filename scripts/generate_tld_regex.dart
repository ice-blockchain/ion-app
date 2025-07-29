import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  // Download the official IANA TLD list
  const tldUrl = 'https://data.iana.org/TLD/tlds-alpha-by-domain.txt';
  final httpClient = HttpClient();
  final request = await httpClient.getUrl(Uri.parse(tldUrl));
  final response = await request.close();
  if (response.statusCode != HttpStatus.ok) {
    stderr.writeln('ERROR: Failed to download TLD list (HTTP ${response.statusCode})');
    exit(1);
  }
  final rawLines = await response.transform(utf8.decoder).transform(const LineSplitter()).toList();

  // 1) Read, trim, drop empty/comment lines
  final tlds = rawLines
      .map((l) => l.trim().toLowerCase())
      .where((l) => l.isNotEmpty && !l.startsWith('#'))
      .toList();

  if (tlds.isEmpty) {
    stderr.writeln('ERROR: No TLDs found.');
    exit(2);
  }

  // 2) Build the regex group
  final group = '(?:' + tlds.join('|') + ')';

  // 3) Write a complete Dart source file
  const outputPath = 'lib/generated/tlds_group.dart';
  final outFile = File(outputPath);
  // Ensure the target directory exists
  outFile.parent.createSync(recursive: true);
  final content =
      '''
// GENERATED — do not edit by hand.
const String tldGroup = '$group';
''';
  outFile.writeAsStringSync(content);
  print('Wrote generated TLD group to $outputPath');
  httpClient.close(force: true);
  exit(0);
}
