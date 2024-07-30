import 'dart:convert';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart';

final iv = enc.IV.fromUtf8('1111111111111111');

Future<String> encryptingData(String encryptingText, bool isPrd) async {
  final Ekey = enc.Key.fromUtf8(isPrd
      ? '8Xjs667RSI27FAss0tLZdUX7UiTSXfNV'
      : 'z6kMLBOnwhG2Zs9ziGles42GheKVmSco');
  String EncryptedText;
  try {
    final encrypter =
        enc.Encrypter(enc.AES(Ekey, mode: enc.AESMode.ctr, padding: null));
    final encrypted = encrypter.encrypt(
      encryptingText,
      iv: iv,
    );
    EncryptedText = encrypted.base64;
    return EncryptedText;
  } on Exception catch (e) {
    EncryptedText = e.toString();
    return EncryptedText;
  }
}

Future<dynamic> dencryptingData(String decryptingText, bool isPrd) async {
  final Dkey = enc.Key.fromUtf8(isPrd
      ? '8Xjs667RSI27FAss0tLZdUX7UiTSXfNV'
      : 'z6kMLBOnwhG2Zs9ziGles42GheKVmSco');

  String decryptedString;

  try {
    final decrypter =
        enc.Encrypter(enc.AES(Dkey, mode: enc.AESMode.ctr, padding: null));
    final decrypted =
        decrypter.decryptBytes(Encrypted.from64(decryptingText), iv: iv);
    decryptedString = utf8.decode(decrypted);
    print(decryptedString);
    return decryptedString;
  } on Exception catch (e) {
    decryptedString = e.toString();
    return decryptedString;
  }
}
