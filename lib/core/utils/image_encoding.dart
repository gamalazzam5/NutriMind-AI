import 'dart:convert';
import 'dart:io';

Future<String> encodeImageFileToBase64(String path) async {
  final bytes = await File(path).readAsBytes();
  return base64Encode(bytes);
}


String resolveImageMimeType(String path) {
  final extension = path.split('.').last.toLowerCase();
  return switch (extension) {
    'png' => 'image/png',
    'webp' => 'image/webp',
    'heic' => 'image/heic',
    _ => 'image/jpeg',
  };
}
