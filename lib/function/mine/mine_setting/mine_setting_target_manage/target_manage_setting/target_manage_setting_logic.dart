import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:flutter_report_project/generated/json/store_entity.g.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../config/rs_locale.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../../model/store/store_entity.dart';
import '../../../../../model/target_manage/target_manage_shops_entity.dart';
import '../../../../../utils/date_util.dart';
import '../../../../../utils/network/models/api_response_entity.dart';
import '../../../../../utils/network/server_url.dart';
import '../../../../../utils/utils.dart';
import 'target_manage_setting_state.dart';

class TargetManageSettingLogic extends GetxController {
  final TargetManageSettingState state = TargetManageSettingState();

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

  // 设置编辑页面数据
  void setEditPageData() {
    // 月份
    if (state.infoEntity.value.month != null && state.infoEntity.value.month!.isNotEmpty) {
      setMonthSubTitle(state.infoEntity.value.month!);
    }

    // 指标
    if (state.infoEntity.value.metricCode != null && state.infoEntity.value.metricCode!.isNotEmpty) {
      state.selectedMetricsIndex.value = state.editConfigEntity.value.metrics!
          .indexWhere((element) => element.code == state.infoEntity.value.metricCode);
    }

    // 分配方式
    if (state.infoEntity.value.distributionType != null) {
      state.selectedDistributionIndex.value = TargetManageDistributionType.values.indexWhere(
          (element) => element == (state.infoEntity.value.distributionType ?? TargetManageDistributionType.values[0]));
      // 设置分配方式标题
      setDistributionTitles();
    }

    // 目标金额
    if (state.infoEntity.value.subTargets != null &&
        state.infoEntity.value.subTargets!.isNotEmpty &&
        state.infoEntity.value.target != null &&
        state.infoEntity.value.target!.isNotEmpty) {
      if (state.infoEntity.value.subTargets?.length == state.textEditingControllerList.length) {
        // 遍历输入框控制器并赋值金额
        for (int i = 0; i < state.infoEntity.value.subTargets!.length; i++) {
          state.textEditingControllerList[i].text = state.infoEntity.value.subTargets![i];
        }
      }

      state.totalAmount.value = BigInt.parse(state.infoEntity.value.target ?? '0');
    }

    // 应用门店
    if (state.infoEntity.value.shopIds != null && state.infoEntity.value.shopIds!.isNotEmpty) {
      state.selectedShops.clear();
      state.infoEntity.value.shopIds?.forEach((shopId) {
        // 根据shopId 查找相应的门店数据模型
        state.storeEntity.value.currencyShops?.forEach((currencyShop) {
          // debugPrint(
          //     "currencyShop.currency?.value = ${currencyShop.currency?.value} -- ${state.infoEntity.value.currency}");
          if (currencyShop.currency?.value == state.infoEntity.value.currency) {
            // 赋值货币value
            state.selectedCurrencyValue.value = currencyShop.currency?.value ?? '';

            // 遍历currencyShop.allShops
            if (currencyShop.allShops != null && currencyShop.allShops!.isNotEmpty) {
              currencyShop.allShops?.forEach((allShop) {
                allShop.brandShops?.forEach((brandShop) {
                  // 赋值选中门店信息
                  if (brandShop.shopId == shopId) {
                    state.selectedShops.add(StoreCurrencyShopsGroupShopsBrandShops.fromJson(brandShop.toJson()));
                  }
                });
              });
            }
          }
        });
      });
    }
  }

  // 目标管理-添加或修改目标
  Future<void> addOrUpdateTarget() async {
    await request(() async {
      // 遍历出已选择门店id，并过滤空值
      List<String> shopIds = state.selectedShops.map((shop) => shop.shopId ?? "").toList();
      String month = DateUtil.formatDate(state.startDate.value, format: 'yyyyMM');
      String metricCode = state.editConfigEntity.value.metrics?[state.selectedMetricsIndex.value].code ?? '';
      String distributionType = TargetManageDistributionType.values[state.selectedDistributionIndex.value].name;
      List<String> subTargets = state.textEditingControllerList.map((controller) {
        debugPrint('controller.text: ${controller.text}');
        return controller.text.replaceAll(',', '');
      }).toList();

      var params = {
        "shopIds": shopIds,
        "month": month,
        "metricCode": metricCode,
        "distributionType": distributionType,
        "totalTarget": state.totalAmount.value.toString(),
        "subTargets": subTargets,
        "targetCurrency": state.selectedCurrencyValue.value,
      };

      // 判断是否是编辑状态，如果是，则添加targetId参数
      if (state.targetId.isNotEmpty) {
        params['targetId'] = state.targetId;
      }

      await requestClient.request(
          state.targetId.isNotEmpty ? RSServerUrl.targetManageUpdate : RSServerUrl.targetManageAdd,
          method: RequestType.post,
          data: params, onError: (e) {
        debugPrint('onError: $e');
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint("response: ${response.data}");

        var tmpResponseData = response.data;

        if (tmpResponseData != null && tmpResponseData is Map<String, dynamic>) {
          if (tmpResponseData.containsKey("success")) {
            bool success = tmpResponseData["success"];
            if (success) {
              Get.back(result: true);
            }
          }
        } else {
          EasyLoading.showError('${response.code}\n${response.msg}');
        }
      });
    }, showLoading: true);
  }

  // 目标管理-删除目标
  Future<void> deleteTarget() async {
    var params = {
      'targetId': state.targetId,
    };

    await request(() async {
      await requestClient.request(RSServerUrl.targetManageDelete, method: RequestType.post, data: params, onError: (e) {
        debugPrint('onError: $e');
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint("response: ${response.data}");

        var tmpResponseData = response.data;

        if (tmpResponseData != null && tmpResponseData is Map<String, dynamic>) {
          if (tmpResponseData.containsKey("success")) {
            bool success = tmpResponseData["success"];
            if (success) {
              Get.back(result: true);
            }
          }
        } else {
          EasyLoading.showError('${response.code}\n${response.msg}');
        }
      });
    }, showLoading: true);
  }

  // 当分配方式为'按工作日'时，需要在state.titles[1]中添加'工作日'、'休息日'选项
  // 当分配方式为'按星期'时，需要在state.titles[1]中添加'星期一'至'星期日'七个选项
  // 当分配方式为'按天'时，需要在state.titles[1]中添加'平均每天'选项
  void setDistributionTitles() {
    if (state.selectedDistributionIndex.value == 0) {
      state.titles[1] = [S.current.rs_distribution_method, S.current.rs_workday, S.current.rs_rest_day];
    } else if (state.selectedDistributionIndex.value == 1) {
      if (RSLocale().locale?.languageCode == 'zh') {
        state.titles[1] = [S.current.rs_distribution_method, '星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
      } else {
        state.titles[1] = [S.current.rs_distribution_method, 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      }
    } else if (state.selectedDistributionIndex.value == 2) {
      state.titles[1] = [S.current.rs_distribution_method, S.current.rs_daily_average];
    }

    createTextEditingController();
  }

// 循环创建TextEditingController，用于存储输入框的值，长度为state.titles[1].length - 1
  void createTextEditingController() {
    state.textEditingControllerList.clear();
    for (int i = 0; i < state.titles[1].length - 1; i++) {
      state.textEditingControllerList.add(TextEditingController());
    }
  }

  void updateTimeRange(List<String> timeRange) {
    state.startDate.value = DateTime.tryParse(timeRange.first) ?? state.startDate.value;
    state.endDate.value = DateTime.tryParse(timeRange.last) ?? state.endDate.value;
  }

// 赋值月份副标题
  String setMonthSubTitle(String yyyyMM) {
    String subtitle = '';
    if (yyyyMM.length == 6) {
      int year = int.parse(yyyyMM.substring(0, 4)); // 获取前四位作为年份
      int month = int.parse(yyyyMM.substring(4, 6)); // 获取后两位作为月份
      DateTime dateTime = DateTime(year, month);
      subtitle = DateFormat(DateFormats.y_mo).format(dateTime);
      subtitle = RSDateUtil.dateRangeToString([dateTime], dateFormat: DateFormats.y_mo);

      state.startDate.value = dateTime;
      state.endDate.value = dateTime;
    } else {
      subtitle =
          RSDateUtil.dateRangeToString([state.startDate.value, state.endDate.value], dateFormat: DateFormats.y_mo);
    }

    return subtitle;
  }

  /// 获取配置相关的门店列表
  Future<void> getTargetsShops() async {
    // 当月份、指标不为空，并发生变化时，重新获取门店列表
    if (state.selectedMetricsIndex.value == -1) {
      return;
    }

    await request(() async {
      var params = {
        "month":
            RSDateUtil.dateRangeToString([state.startDate.value, state.endDate.value], dateFormat: DateFormats.y_mo)
                .replaceAll('/', ''),
        "metricCode": state.editConfigEntity.value.metrics?[state.selectedMetricsIndex.value].code,
      };

      // 判断是否是编辑状态，如果是，则添加targetId参数
      if (state.targetId.isNotEmpty) {
        params['targetId'] = state.targetId;
      }

      TargetManageShopsEntity? entity = await requestClient
          .request(RSServerUrl.targetManageEditShops, method: RequestType.post, data: params, onError: (e) {
        return false;
      }, onResponse: (response) {});

      if (entity != null) {
        debugPrint("TargetManageShopsEntity: ${entity.toJson()}");
        state.targetManageShopsEntity.value = entity;

        handleStoreEntity();
      }
    }, showLoading: true);
  }

  /// 处理门店数据模型
  void handleStoreEntity() {
    allSelectedShopsFalse();

    state.targetManageShopsEntity.value.currencyShop?.forEach((currencyShop) {
      state.storeEntity.value.currencyShops?.forEach((storeCurrencyShop) {
        // 判断货币是否相同
        if (storeCurrencyShop.currency?.value == currencyShop.currency) {
          // 处理 unconfigurableShopIds 数组
          currencyShop.unconfigurableShopIds?.forEach((shopId) {
            // 遍历删除
            storeCurrencyShop.allShops?.forEach((shopGroup) {
              shopGroup.brandShops?.removeWhere((brandShop) {
                return brandShop.shopId == shopId;
              });
            });
            // 遍历删除
            storeCurrencyShop.groupShops?.forEach((groupShop) {
              groupShop.brandShops?.removeWhere((brandShop) {
                return brandShop.shopId == shopId;
              });
            });
          });

          // 处理 currentConfigShopIds 数组
          currencyShop.currentConfigShopIds?.forEach((shopId) {
            // 遍历修改
            storeCurrencyShop.allShops?.forEach((shopGroup) {
              shopGroup.brandShops?.forEach((brandShop) {
                if (brandShop.shopId == shopId) {
                  brandShop.isSelected = true;
                  brandShop.isEditable = true;
                }
              });
            });
            // 遍历修改
            storeCurrencyShop.groupShops?.forEach((groupShop) {
              groupShop.brandShops?.forEach((brandShop) {
                if (brandShop.shopId == shopId) {
                  brandShop.isSelected = true;
                  brandShop.isEditable = true;
                }
              });
            });
          });

          // 处理 relatedConfigShopIds 数组
          currencyShop.relatedConfigShopIds?.forEach((shopId) {
            // 遍历修改
            storeCurrencyShop.allShops?.forEach((shopGroup) {
              shopGroup.brandShops?.forEach((brandShop) {
                if (brandShop.shopId == shopId) {
                  brandShop.isSelected = true;
                  brandShop.isEditable = false;
                }
              });
            });
            // 遍历修改
            storeCurrencyShop.groupShops?.forEach((groupShop) {
              groupShop.brandShops?.forEach((brandShop) {
                if (brandShop.shopId == shopId) {
                  brandShop.isSelected = true;
                  brandShop.isEditable = false;
                }
              });
            });
          });
        }
      });
    });
  }

  /// 所有门店选择状态置为false
  void allSelectedShopsFalse() {
    state.storeEntity.value.currencyShops?.forEach((currencyShop) {
      _setAllShopsSelectedFalse(currencyShop.allShops);
      _setAllShopsSelectedFalse(currencyShop.groupShops);
    });
    // 更新storeEntity
    state.storeEntity.value = state.storeEntity.value.copyWith();
  }

  void _setAllShopsSelectedFalse(List<StoreCurrencyShopsGroupShops>? shops) {
    shops?.forEach((groupShop) {
      groupShop.brandShops?.forEach((shop) {
        shop.isSelected = false;
      });
    });
  }

// 获取所有输入框内容
  BigInt getAllInputValues() {
    List<String> tmp = state.textEditingControllerList.map((controller) {
      debugPrint('controller.text: ${controller.text}');
      return controller.text.replaceAll(',', '');
    }).toList();

    if (tmp.isEmpty) {
      return BigInt.zero;
    }

    BigInt totalAmount = BigInt.zero;

    // 获取当前日期
    DateTime now = state.startDate.value;

    if (state.selectedDistributionIndex.value == 0) {
      // 按工作日

      // 获取当前月份的第一天和最后一天
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      int workdays = 0;
      int weekends = 0;

      // 遍历本月的每一天
      for (DateTime date = firstDayOfMonth;
          date.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))) {
        // 判断是工作日还是休息日
        if (date.weekday >= 1 && date.weekday <= 5) {
          // 工作日（周一到周五）
          workdays++;
        } else {
          // 休息日（周六和周日）
          weekends++;
        }
      }

      var workdaysAmount =
          (BigInt.tryParse(tmp[0]) ?? BigInt.zero) * (BigInt.tryParse(workdays.toString()) ?? BigInt.zero);
      var weekendsAmount =
          (BigInt.tryParse(tmp[1]) ?? BigInt.zero) * (BigInt.tryParse(weekends.toString()) ?? BigInt.zero);

      totalAmount += workdaysAmount + weekendsAmount;

      // 输出结果
      print('当前月份总工作日: $workdays');
      print('当前月份总休息日: $weekends');
    } else if (state.selectedDistributionIndex.value == 1) {
      // 按星期

      // 获取当前月份的第一天和最后一天
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      // 初始化统计数组，索引 0 = 周一, 1 = 周二, ..., 6 = 周日
      List<int> weekdaysCount = List.filled(7, 0);

      // 遍历本月的每一天
      for (DateTime date = firstDayOfMonth;
          date.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))) {
        // 判断是星期几并增加对应计数
        weekdaysCount[date.weekday - 1]++; // weekday 返回值为 1 (周一) 到 7 (周日)
      }

      for (int i = 0; i < weekdaysCount.length; i++) {
        var amount =
            (BigInt.tryParse(tmp[i]) ?? BigInt.zero) * (BigInt.tryParse(weekdaysCount[i].toString()) ?? BigInt.zero);
        totalAmount += amount;
      }

      // 输出结果
      print('当前月份各星期几的天数：');
      print('周一: ${weekdaysCount[0]}');
      print('周二: ${weekdaysCount[1]}');
      print('周三: ${weekdaysCount[2]}');
      print('周四: ${weekdaysCount[3]}');
      print('周五: ${weekdaysCount[4]}');
      print('周六: ${weekdaysCount[5]}');
      print('周日: ${weekdaysCount[6]}');
    } else {
      // 按天

      // 获取当前月份的总天数
      int totalDays = DateTime(now.year, now.month + 1, 0).day;

      totalAmount = (BigInt.tryParse(tmp[0]) ?? BigInt.zero) * (BigInt.tryParse(totalDays.toString()) ?? BigInt.zero);

      // 输出结果
      print('当前月份总天数: $totalDays');
    }

    return totalAmount;
  }

// 将Bigint转换为字符串，并添加千位分隔符
  String bigIntToStringWithThousandsSeparator(BigInt value) {
    String formattedValue = value.toString();
    int index = formattedValue.length - 3;
    while (index > 0) {
      formattedValue = '${formattedValue.substring(0, index)},${formattedValue.substring(index)}';
      index -= 3;
    }
    return formattedValue;
  }

// 按月计算
  void calculateByMonths() {
    // 获取当前日期
    DateTime now = state.startDate.value;

    // 获取当前月份的总天数
    int totalDays = DateTime(now.year, now.month + 1, 0).day;

    // 输出结果
    print('当前月份总天数: $totalDays');
  }

// 校验指标、分配方式、门店是否已选择
  bool validate() {
    // 指标
    if (state.selectedMetricsIndex.value == -1) {
      state.metricsErrorTip.value = true;
      EasyLoading.showToast(S.current.rs_add_metric_tip);
      return false;
    } else {
      state.metricsErrorTip.value = false;
    }

    // 分配方式
    if (state.selectedDistributionIndex.value == -1) {
      state.distributionErrorTip.value = true;
      EasyLoading.showToast('${S.current.rs_please_select}${S.current.rs_distribution_method}');
      return false;
    } else {
      state.distributionErrorTip.value = false;
    }

    // 输入框控制器，并去除空数据
    List<String> tmpTextEditingControllerList = state.textEditingControllerList.map((controller) {
      debugPrint('controller.text: ${controller.text}');
      return controller.text.replaceAll(',', '');
    }).toList();
    tmpTextEditingControllerList.removeWhere((element) => element.isEmpty);

    if (tmpTextEditingControllerList.length != state.textEditingControllerList.length) {
      EasyLoading.showToast(S.current.rs_amount_not_entered);
      state.distributionErrorTip.value = true;
      return false;
    } else {
      state.distributionErrorTip.value = false;
    }

    // 应用门店
    if (state.selectedShops.isEmpty) {
      state.selectedShopsErrorTip.value = true;
      EasyLoading.showToast('${S.current.rs_please_select}${S.current.rs_application_store}');
      return false;
    } else {
      state.selectedShopsErrorTip.value = false;
    }

    RSUtils.hideKeyboard();

    return true;
  }

// 根据货币value找到 货币name
  String getCurrencySymbolByValue(String value) {
    String currencyName = '';
    RSAccountManager().getAllCurrency().forEach((element) {
      if (element.value == value) {
        currencyName = element.symbol ?? '';
      }
    });

    return currencyName;
  }

// 清除应用门店
  void clearSelectedShops() {
    // 重置所有门店的选中状态
    RSAccountManager().allSelectedShopsFalse(state.storeEntity.value);
    // 选中的门店
    state.selectedShops.clear();
    // 选中的货币value
    state.selectedCurrencyValue.value = RSAccountManager().getCurrency()?.value ?? "";
  }
}
