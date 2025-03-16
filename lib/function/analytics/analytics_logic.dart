import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/function/login/account_manager/account_manager.dart';
import 'package:flutter_report_project/model/business_topic/topic_template_entity.dart';
import 'package:flutter_report_project/model/store/store_entity.dart';
import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:flutter_report_project/widget/load_state_layout.dart';
import 'package:get/get.dart';

import '../../model/business_topic/business_topic_type_enum.dart';
import '../../model/user/user_info_entity.dart';
import '../../utils/logger/logger_helper.dart';
import '../../utils/network/request.dart';
import 'analytics_state.dart';

class AnalyticsLogic extends GetxController {
  final AnalyticsState state = AnalyticsState();

  VoidCallback? refreshTabCallback;

  @override
  void onReady() {
    super.onReady();

    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    super.onClose();

    logger.d("onClose", StackTrace.current);
  }

  Future<void> loadAllData() async {
    state.loadState.value = LoadState.stateLoading;
    getUserInfoRequest(() async {
      await getShopOrgInfoRequest(() async {
        await loadUserTopicTemplate();
      });
    }, false);
  }

  /// 获取用户模板
  Future<void> loadUserTopicTemplate() async {
    return await request(() async {
      TopicTemplateEntity? entity = await requestClient.request(
        RSServerUrl.userTemplate,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          debugPrint('原始 error = ${error.message}');
          state.loadState.value = LoadState.stateError;
          return false;
        },
      );

      if (entity != null) {
        state.topicTemplateEntity.value = entity;

        // 设置tab
        setTopicTabs();

        if (entity.templates?.first.navs != null) {
          state.loadState.value = LoadState.stateSuccess;
        } else {
          state.loadState.value = LoadState.stateEmpty;
        }
      } else {
        state.loadState.value = LoadState.stateEmpty;
      }
    });
  }

  /// 设置tab
  void setTopicTabs() {
    List<String> tmpTabs = [];
    state.topicTemplateEntity.value.templates?.first.navs?.first.tabs?.forEach((element) {
      if (element.tabName != null && !element.ifHidden) {
        tmpTabs.add(element.tabName!);
      }
    });
    state.tabs.value = tmpTabs;

    refreshTabCallback?.call();
  }

  /// 获取用户信息
  void getUserInfoRequest(Function() block, bool showLoading) async {
    await request(() async {
      UserInfoEntity? entity = await requestClient.request(
        RSServerUrl.profile,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          state.loadState.value = LoadState.stateError;
          return false;
        },
      );

      if (entity != null) {
        // 更新用户信息
        await RSAccountManager().updateUserInfo(entity);
      }
      block.call();
    }, showLoading: showLoading);
  }

  /// 获取组织门店信息
  Future<void> getShopOrgInfoRequest(Function() block) async {
    await request(() async {
      StoreEntity? storeEntity = await requestClient.request(
        RSServerUrl.shopOrgInfo,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          state.loadState.value = LoadState.stateError;

          return false;
        },
      );

      if (storeEntity != null) {
        debugPrint("获取组织门店信息:$storeEntity");

        // 获取用户选中的分组类型
        storeEntity.selectedGroupType = RSAccountManager().getSelectedGroupType();

        RSAccountManager().storeEntity = storeEntity;

        RSAccountManager().storeEntity?.currencyShops?.forEach((group) {
          group.groupShops?.forEach((element) {
            element.brandShops?.forEach((shop) {
              shop.shopName ??= RSAccountManager().findShopName(shop.shopId);
            });
          });

          group.allShops?.forEach((element) {
            element.brandShops?.forEach((shop) {
              shop.shopName ??= RSAccountManager().findShopName(shop.shopId);
            });
          });
        });

        // 设置已选中的品牌
        RSAccountManager().setSelectedStoreBrands();
        if (RSAccountManager().selectedShops.isNotEmpty) {
          var findCurrency = RSAccountManager()
              .getAllCurrency()
              .firstWhere((element) => element.value == RSAccountManager().getCurrency()?.value);

          int index = RSAccountManager().getAllCurrency().indexOf(findCurrency);

          List<StoreCurrencyShopsGroupShops>? groupShops;
          // 判断是哪个分组
          switch (RSAccountManager().storeEntity?.selectedGroupType) {
            case StoreSelectedGroupType.allType:
              groupShops = RSAccountManager().storeEntity?.currencyShops?[index].allShops;
            case StoreSelectedGroupType.groupType:
              groupShops = RSAccountManager().storeEntity?.currencyShops?[index].groupShops;
            default:
              groupShops = RSAccountManager().storeEntity?.currencyShops?[index].allShops;
          }

          if (index != -1) {
            for (var selectedShop in RSAccountManager().selectedShops) {
              groupShops?.forEach((group) {
                group.brandShops?.forEach((shop) {
                  if (selectedShop.shopId == shop.shopId) {
                    shop.isSelected = true;
                  }
                });
              });
            }
          } else {
            for (var selectedShop in RSAccountManager().selectedShops) {
              RSAccountManager().storeEntity?.currencyShops?.forEach((element) {
                groupShops?.forEach((group) {
                  group.brandShops?.forEach((shop) {
                    if (selectedShop.shopId == shop.shopId) {
                      shop.isSelected = true;
                    }
                  });
                });
              });
            }
          }
        } else {
          RSAccountManager().selectedShops = RSAccountManager().findAllShopsBaseBrandAndCurrency();
        }

        state.selectedShops.value = RSAccountManager().selectedShops;
      }

      block.call();
    }, showLoading: false);
  }
}
