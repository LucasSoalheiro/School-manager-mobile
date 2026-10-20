import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/session_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final List<dynamic>? issues;

  ApiException(this.message, {this.statusCode, this.issues});

  @override
  String toString() => message;
}

class ApiClient {
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;
  final SessionStorage _sessionStorage;
  void Function()? onUnauthorized;

  ApiClient({http.Client? client, required this._sessionStorage, this.onUnauthorized})
      : _client = client ?? http.Client();

  String get _baseUrl => _sessionStorage.getBaseUrl();

  Map<String, String> _buildHeaders({bool includeAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = _sessionStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Uri _buildUri(String path, [Map<String, String>? queryParams]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = '$_baseUrl$cleanPath';
    return Uri.parse(fullUrl).replace(queryParameters: queryParams);
  }

  /// Executes an HTTP request and normalizes transport/network failures into
  /// [ApiException] instances so the presentation layer always receives a
  /// readable message.
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(_timeout);
      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        'Não foi possível conectar ao servidor ($_baseUrl). Verifique sua conexão e certifique-se de que a API está rodando.',
      );
    } on HandshakeException {
      throw ApiException(
        'Não foi possível estabelecer uma conexão segura com ($_baseUrl). Verifique o certificado do servidor.',
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        'Falha de comunicação com o servidor ($_baseUrl): ${e.message}',
      );
    } on TimeoutException {
      throw ApiException(
        'A requisição expirou. O servidor demorou muito para responder.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro inesperado de comunicação: $e');
    }
  }

  Future<dynamic> get(String path, {Map<String, String>? queryParams, bool includeAuth = true}) {
    return _send(
      () => _client.get(
        _buildUri(path, queryParams),
        headers: _buildHeaders(includeAuth: includeAuth),
      ),
    );
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) {
    return _send(
      () => _client.post(
        _buildUri(path),
        headers: _buildHeaders(includeAuth: includeAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) {
    return _send(
      () => _client.put(
        _buildUri(path),
        headers: _buildHeaders(includeAuth: includeAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) {
    return _send(
      () => _client.patch(
        _buildUri(path),
        headers: _buildHeaders(includeAuth: includeAuth),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> delete(String path, {bool includeAuth = true}) {
    return _send(
      () => _client.delete(
        _buildUri(path),
        headers: _buildHeaders(includeAuth: includeAuth),
      ),
    );
  }

  dynamic _processResponse(http.Response response) {
    dynamic decodedBody;
    if (response.body.isNotEmpty) {
      try {
        decodedBody = jsonDecode(response.body);
      } catch (_) {
        decodedBody = response.body;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    }

    if (response.statusCode == 401) {
      unawaited(_sessionStorage.clearSession());
      onUnauthorized?.call();
    }

    // Processamento de mensagens de erro da API
    String errorMessage = 'Ocorreu um erro na requisição (${response.statusCode})';
    List<dynamic>? issues;

    if (decodedBody is Map<String, dynamic>) {
      if (decodedBody.containsKey('message') && decodedBody['message'] != null) {
        errorMessage = decodedBody['message'].toString();
      } else if (decodedBody.containsKey('error') && decodedBody['error'] != null) {
        errorMessage = decodedBody['error'].toString();
      }

      if (decodedBody.containsKey('issues') && decodedBody['issues'] is List) {
        issues = decodedBody['issues'] as List<dynamic>;
        if (issues.isNotEmpty) {
          final firstIssue = issues.first;
          if (firstIssue is Map && firstIssue.containsKey('message')) {
            errorMessage = '${firstIssue['message']}';
          }
        }
      }
    }

    throw ApiException(
      errorMessage,
      statusCode: response.statusCode,
      issues: issues,
    );
  }
}
