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
  final http.Client _client;
  final SessionStorage _sessionStorage;

  ApiClient({http.Client? client, required this._sessionStorage})
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

  Future<dynamic> get(String path, {Map<String, String>? queryParams, bool includeAuth = true}) async {
    try {
      final uri = _buildUri(path, queryParams);
      final response = await _client
          .get(uri, headers: _buildHeaders(includeAuth: includeAuth))
          .timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        'Não foi possível conectar ao servidor ($_baseUrl). Verifique sua conexão e certifique-se de que a API está rodando.',
      );
    } on TimeoutException {
      throw ApiException('A requisição expirou. O servidor demorou muito para responder.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro inesperado de comunicação: $e');
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final uri = _buildUri(path);
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(includeAuth: includeAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        'Não foi possível conectar ao servidor ($_baseUrl). Verifique sua conexão e a URL configurada.',
      );
    } on TimeoutException {
      throw ApiException('A requisição expirou.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final uri = _buildUri(path);
      final response = await _client
          .put(
            uri,
            headers: _buildHeaders(includeAuth: includeAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on SocketException {
      throw ApiException('Não foi possível conectar ao servidor.');
    } on TimeoutException {
      throw ApiException('A requisição expirou.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final uri = _buildUri(path);
      final response = await _client
          .patch(
            uri,
            headers: _buildHeaders(includeAuth: includeAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on SocketException {
      throw ApiException('Não foi possível conectar ao servidor.');
    } on TimeoutException {
      throw ApiException('A requisição expirou.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  Future<dynamic> delete(String path, {bool includeAuth = true}) async {
    try {
      final uri = _buildUri(path);
      final response = await _client
          .delete(uri, headers: _buildHeaders(includeAuth: includeAuth))
          .timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } on SocketException {
      throw ApiException('Não foi possível conectar ao servidor.');
    } on TimeoutException {
      throw ApiException('A requisição expirou.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
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
