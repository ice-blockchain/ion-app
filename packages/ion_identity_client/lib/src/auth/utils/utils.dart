import 'dart:math';

// Generate recovery code (implement as needed)
String generateRecoveryCode() {
  // Implement your recovery code generation logic here
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final random = Random.secure();

  final codeUnits = List<int>.generate(30, (index) {
    final randomByte = random.nextInt(alphabet.length);
    return alphabet.codeUnitAt(randomByte);
  });

  final code = String.fromCharCodes(codeUnits);

  // Format the code with dashes
  return 'D1-'
      '${code.substring(0, 6)}-'
      '${code.substring(6, 11)}-'
      '${code.substring(11, 16)}-'
      '${code.substring(16, 21)}-'
      '${code.substring(21, 26)}-'
      '${code.substring(26)}';
}
