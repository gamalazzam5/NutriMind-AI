import 'dart:convert';
import 'dart:io';

/// Reads the image file at [path] and returns its bytes as a base64 string,
/// for embedding in Gemini `inline_data` request payloads.
Future<String> encodeImageFileToBase64(String path) async {
  final bytes = await File(path).readAsBytes();
  return base64Encode(bytes);
}

/// Resolves a best-effort MIME type from a file path's extension. Defaults
/// to `image/jpeg`, which covers the common camera/gallery capture case.
String resolveImageMimeType(String path) {
  final extension = path.split('.').last.toLowerCase();
  return switch (extension) {
    'png' => 'image/png',
    'webp' => 'image/webp',
    'heic' => 'image/heic',
    _ => 'image/jpeg',
  };
}
