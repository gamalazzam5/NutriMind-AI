import 'dart:convert';

Map<String, dynamic> parseJsonResponse(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is String && data.isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      return const {};
    }
  }
  return const {};
}
