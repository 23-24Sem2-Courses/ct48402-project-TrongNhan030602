import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/auth_token.dart';
import '../models/http_exception.dart';

enum HttpMethod { get, post, put, patch, delete }

abstract class FirebaseService {
  String? _token;
  String? _userId;
  late final String? databaseUrl;

  FirebaseService([AuthToken? authToken])
      : _token = authToken?.token,
        _userId = authToken?.userId {
    databaseUrl = dotenv.env['FIREBASE_RTDB_URL'];
  }

  set authToken(AuthToken? authToken) {
    _token = authToken?.token;
    _userId = authToken?.userId;
  }

  @protected
  String? get token => _token;

  @protected
  String? get userId => _userId;

  Future<dynamic> httpFetch(
    String uri, {
    HttpMethod method = HttpMethod.get,
    Map<String, String>? headers,
    Object? body,
  }) async {
    Uri requestUri = Uri.parse(uri);
    late http.Response response;

    switch (method) {
      case HttpMethod.get:
        response = await http.get(
          requestUri,
          headers: headers,
        );
        break;
      case HttpMethod.post:
        response = await http.post(
          requestUri,
          headers: headers,
          body: body,
        );
        break;
      case HttpMethod.put:
        response = await http.put(
          requestUri,
          headers: headers,
          body: body,
        );
        break;
      case HttpMethod.patch:
        response = await http.patch(
          requestUri,
          headers: headers,
          body: body,
        );
        break;
      case HttpMethod.delete:
        response = await http.delete(
          requestUri,
          headers: headers,
        );
        break;
    }

    if (response.statusCode != 200) {
      throw HttpException(response.body);
    }

    if (response.body.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(response.body);
    } catch (error) {
      throw HttpException('Failed to parse JSON response');
    }
  }
}
