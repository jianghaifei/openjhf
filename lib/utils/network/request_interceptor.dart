import 'package:dio/dio.dart';
import 'package:flutter_report_project/utils/app_info.dart';

import '../../config/rs_locale.dart';
import '../../function/login/account_manager/account_manager.dart';

/// 请求拦截器
class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 登录后获取
    options.headers["Access-Token"] = RSAccountManager().userInfoEntity?.accessToken;
    // 公司id
    options.headers["Corporation-Id"] = RSAccountManager().userInfoEntity?.employee?.corporationId;
    // AppVersion
    options.headers["App-Version"] = RSAppInfo().version;

    if (!options.headers.containsKey("Currency-Type") && RSAccountManager().getCurrency() != null) {
      // 货币符号
      options.headers["Currency-Type"] = RSAccountManager().getCurrency()?.value;
    }

    // 多语言
    var languageCode = RSLocale().locale?.languageCode;

    if (RSLocale().locale?.countryCode != null) {
      var countryCode = RSLocale().locale?.countryCode;
      languageCode = "${languageCode}_$countryCode";
    }

    options.headers["Language-Code"] = languageCode;

    super.onRequest(options, handler);
  }
}
