import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../model/analytics_entity_list/order_detail_entity.dart';
import '../../../../model/analytics_entity_list/order_detail_setting_options_entity.dart';
import '../../../../model/business_topic/business_topic_type_enum.dart';
import '../../../../router/app_routes.dart';
import '../../../../utils/logger/logger_helper.dart';
import '../../../../utils/network/request.dart';
import '../../../../utils/network/request_client.dart';
import '../../../../utils/network/server_url.dart';
import '../../../../widget/load_state_layout.dart';
import 'analytics_entity_detail_state.dart';

class AnalyticsEntityDetailLogic extends GetxController {
  final AnalyticsEntityDetailState state = AnalyticsEntityDetailState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    logger.d("onReady", StackTrace.current);

    var args = Get.arguments;

    if (args != null && args is Map<String, dynamic>) {
      if (args.containsKey("entity") && args.containsKey("dimId") && args.containsKey("dimIdCode")) {
        state.entity = args["entity"];
        state.dimId = args["dimId"];
        state.dimIdCode = args["dimIdCode"];
        loadDetailPageData();
      } else if (args.containsKey("parameters")) {
        state.parameters.value = args["parameters"];
        loadDetailPageData();
      } else {
        EasyLoading.showError("Missing parameter: Entity");
        logger.w("onReady - Missing parameter: Entity", StackTrace.current);
        Get.back();
      }
    } else {
      EasyLoading.showError("Missing parameter: Entity");
      logger.w("onReady - Missing parameter: Entity", StackTrace.current);
      Get.back();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    state.isClosed = true;
    logger.d("onClose", StackTrace.current);
  }

  /// 加载订单详细信息基本选项
  void loadOrderDetailBaseOptions() async {
    await request(() async {
      OrderDetailSettingOptionsEntity? entityModel =
          await requestClient.request(RSServerUrl.getOrderDetailBaseOptions, method: RequestType.post, data: {
        "entity": state.entity,
      }, onResponse: (response) {
        debugPrint("response = $response");
      }, onError: (error) {
        return false;
      });

      if (entityModel != null) {
        debugPrint("response = ${entityModel.toJson()}");
        Get.toNamed(AppRoutes.orderDetailSettingPage, arguments: {
          "entityModel": entityModel,
          "entity": state.entity,
        })?.then((result) async {
          if (result != null && result) {
            loadDetailPageData();
          }
        });
      }
    }, showLoading: true);
  }

  /// 加载订单详细信息
  Future<void> loadDetailPageData() async {
    await request(() async {
      state.loadState.value = LoadState.stateLoading;

      var params = {};
      if (state.parameters.isEmpty) {
        params = {
          state.dimIdCode: state.dimId,
          "entity": state.entity,
        };
      } else {
        state.parameters.map((element) {
          params[element.name] = element.value;
        }).toList();
      }

      OrderDetailEntity? entityModel = await requestClient.request(
          state.parameters.isEmpty ? RSServerUrl.getOrderDetailPage : RSServerUrl.diningTablePendingOrderDetail,
          method: RequestType.post,
          data: params, onResponse: (response) {
        debugPrint("response = $response");
      }, onError: (error) {
        state.errorCode = error.code;
        state.errorMessage = error.message;
        state.loadState.value = LoadState.stateError;
        return false;
      });

      if (entityModel != null) {
        // 是否自定义入参进来
        if (state.parameters.isEmpty) {
          state.loadState.value = LoadState.stateSuccess;
          debugPrint("response = ${entityModel.toJson()}");
          state.orderDetailEntity.value = entityModel;
          dataConfiguration();
        } else {
          // 未拉取到数据，开始轮询
          if (entityModel.fetchStatus == 0) {
            if (!state.isClosed) {
              Future.delayed(const Duration(seconds: 2), () {
                if (!state.isClosed) {
                  loadDetailPageData();
                }
              });
            }
          } else {
            state.loadState.value = LoadState.stateSuccess;
            debugPrint("response = ${entityModel.toJson()}");
            state.orderDetailEntity.value = entityModel;
            dataConfiguration();
          }
        }
      } else {
        state.loadState.value = LoadState.stateEmpty;
      }
    });
  }

  /// 数据配置
  void dataConfiguration() {
    if (state.orderDetailEntity.value.divs != null && state.orderDetailEntity.value.divs?.first != null) {
      var tmpRowLimit = state.orderDetailEntity.value.divs?.first.rowLimit ?? -1;
      var tmpRowsLength = state.orderDetailEntity.value.divs?.first.rows?.length ?? 0;
      // 是否显示More
      state.isShowMore = tmpRowLimit < tmpRowsLength;
    }
  }

  /// 跳转至新详情页
  void jumpNewDetailPage(OrderDetailDivsRowsColumnsRelatedInfo? relatedInfo) {
    if (relatedInfo != null) {
      logger.d("跳转至订单详情页", StackTrace.current);

      Get.toNamed(AppRoutes.analyticsEntityDetailPage,
          arguments: {
            "dimId": relatedInfo.fieldValue,
            "dimIdCode": relatedInfo.fieldCode,
            "entity": relatedInfo.entity,
          },
          preventDuplicates: false);
    }
  }

  TextAlign convertStringToTextAlign(OrderDetailContentTextAlign? textAlign) {
    switch (textAlign) {
      case OrderDetailContentTextAlign.LEFT:
        return TextAlign.left;
      case OrderDetailContentTextAlign.RIGHT:
        return TextAlign.right;
      case OrderDetailContentTextAlign.CENTER:
        return TextAlign.center;
      default:
        return TextAlign.left;
    }
  }
}
