import 'package:flustars/flustars.dart';

import '../login_state.dart';

/// 历史账号管理
class HistoryAccountManager {
  static const kHistoryAccountEmail = 'kHistoryAccountEmail';
  static const kHistoryAccountPhone = 'kHistoryAccountPhone';

  /// 删除单个账号
  static void delAccount(String account, LoginType type) async {
    List<String> list = SpUtil.getStringList(returnKeyWithType(type)) ?? [];

    if (list.contains(account)) {
      list.remove(account);

      SpUtil.putStringList(returnKeyWithType(type), list);
    }
  }

  /// 保存单个账号，如果重复重新排序
  static void saveAccount(String account, LoginType type) {
    List<String> list = getAccounts(type).toList();
    // 去重并重新排序
    if (list.contains(account)) {
      list.remove(account);
    }
    list.insert(0, account);

    saveAccountList(list, type);
  }

  /// 保存列表
  static void saveAccountList(List<String> accounts, LoginType type) {
    SpUtil.putStringList(returnKeyWithType(type), accounts);
  }

  /// 获取已经登录的账号列表
  static List<String> getAccounts(LoginType type) {
    var list = SpUtil.getStringList(returnKeyWithType(type)) ?? [];
    return list;
  }

  static String returnKeyWithType(LoginType type) {
    if (type == LoginType.email) {
      return kHistoryAccountEmail;
    } else if (type == LoginType.phone) {
      return kHistoryAccountPhone;
    }
    return "";
  }
}
