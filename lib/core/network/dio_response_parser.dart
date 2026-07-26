import 'dart:convert';

/// n8n's webhook response node is expected to send `application/json`, but
/// misconfigured executions can fall back to a JSON-encoded string body.
/// This normalizes either shape into a map at the data-layer boundary.
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
