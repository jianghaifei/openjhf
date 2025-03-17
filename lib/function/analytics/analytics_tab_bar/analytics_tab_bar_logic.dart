import 'package:get/get.dart';

import '../../login/account_manager/account_manager.dart';
import 'analytics_tab_bar_state.dart';

class AnalyticsTabBarLogic extends GetxController {
  final AnalyticsTabBarState state = AnalyticsTabBarState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  bool areDateListsEqual(List<DateTime>? list1, List<DateTime>? list2) {
    // 判空
    if (list1 == null || list2 == null) {
      return false;
    }
    if (list1.isEmpty || list2.isEmpty) {
      return false;
    }

    // 首先比较长度
    if (list1.length != list2.length) {
      return false;
    }

    // 比较每个 DateTime 的时间戳
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].millisecondsSinceEpoch != list2[i].millisecondsSinceEpoch) {
        return false;
      }
    }

    return true; // 两个列表相等
  }

  bool areShopIdListsEqual(List<String>? listA, List<String>? listB) {
    // 判空
    if (listA == null || listB == null) {
      return false;
    }

    if (listA.isEmpty || listB.isEmpty) {
      return false;
    }

    if (listA.length != listB.length) {
      return false;
    }

    Set<String> setA = Set.from(listA);
    Set<String> setB = Set.from(listB);

    return setA.length == setB.length && setA.every(setB.contains);
  }

  bool areCompareDateRangeTypeListsEqual(List<CompareDateRangeType>? listA, List<CompareDateRangeType>? listB) {
    // 如果两个列表都为 null，则它们相同
    if (listA == null && listB == null) {
      return true;
    }

    // 如果其中一个为 null 而另一个不为 null，则它们不相同
    if (listA == null || listB == null) {
      return false;
    }

    // 如果长度不同，则它们不相同
    if (listA.length != listB.length) {
      return false;
    }

    // 逐个比较元素
    for (int i = 0; i < listA.length; i++) {
      if (listA[i] != listB[i]) {
        return false;
      }
    }

    // 如果所有元素都相同，则列表相同
    return true;
  }
}
