/// n8n webhook endpoints backing the chat support and food scanner
/// features. See `n8n/chat-support-workflow.json` and
/// `n8n/scanner-workflow.json` for the deployed workflow definitions.
class ApiEndpoints {
  ApiEndpoints._();

  static const String _n8nBaseUrl = 'https://gamalazzam.app.n8n.cloud';

  static const String chatSupport = '$_n8nBaseUrl/webhook/chat-support';
  static const String scanner = '$_n8nBaseUrl/webhook/scanner';
}
