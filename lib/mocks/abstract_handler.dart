import 'package:dio/dio.dart';

abstract class MockHandler {
  bool canHandle(String url);
  Response handle(RequestOptions options);
}