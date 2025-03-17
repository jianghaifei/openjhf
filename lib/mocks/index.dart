import 'package:dio/dio.dart';
import 'abstract_handler.dart';
import 'handlers/index.dart';

class MockInterceptor extends Interceptor {
  final List<MockHandler> handlers = mockHandlers;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    for (var mockHandler in handlers) {
      if (mockHandler.canHandle(options.path)) {
        handler.resolve(mockHandler.handle(options));
        return;
      }
    }
    super.onRequest(options, handler);
  }
}
