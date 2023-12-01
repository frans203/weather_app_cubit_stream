import "package:http/http.dart" as http;

String httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final reason = response.reasonPhrase;

  final String errorMessage =
      "Request failed\nStatus code: $statusCode\nReason: $reason";

  return errorMessage;
}
