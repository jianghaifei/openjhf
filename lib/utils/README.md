# 小工具

### 网络请求示例

```dart
    const String queryJson = '''
    query{
      initQuery
    }
  ''';

    await request(() async {
      debugPrint('Request Demo Start');

      var tmpResponse = await requestClient
          .request('RSServerUrl.baseUrl', method: RequestType.post, data: json.encode({"query": queryJson}), onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');
        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');
      });
      debugPrint('Request Demo End $tmpResponse');
    }, showLoading: true);
```