import 'package:flutter/cupertino.dart';
import 'package:flutter_report_project/index.dart';
import 'package:scm_mobile/index.dart';
import 'package:flutter_report_project/function/analytics/analytics_add/analytics_add_view.dart';
import 'package:flutter_report_project/function/analytics/single_store_jump/single_store_jump_view.dart';
import 'package:flutter_report_project/function/main/main_binding.dart';
import 'package:flutter_report_project/function/main/main_view.dart';
import 'package:flutter_report_project/function/mine/mine_binding.dart';
import 'package:flutter_report_project/function/mine/mine_setting/mine_setting_language/mine_setting_language_view.dart';
import 'package:flutter_report_project/function/mine/mine_setting/mine_setting_metrics_unit/mine_setting_metrics_unit_view.dart';
import 'package:flutter_report_project/function/mine/mine_setting/mine_setting_theme/mine_setting_theme_view.dart';
import 'package:flutter_report_project/function/mine/mine_setting/mine_setting_view.dart';
import 'package:flutter_report_project/function/mine/mine_view.dart';

import '../function/analytics/analytics_add/analytics_add_template/analytics_add_chart/analytics_add_chart_subviews/analytics_add_chart_sub_views_metric/analytics_add_chart_sub_views_metric_view.dart';
import '../function/analytics/analytics_add/analytics_add_template/analytics_add_chart/analytics_add_chart_view.dart';
import '../function/analytics/analytics_add/analytics_add_template/analytics_add_metric_card/analytics_add_metric_card_step1/analytics_add_metric_card_step1_view.dart';
import '../function/analytics/analytics_add/analytics_add_template/analytics_add_metric_card/analytics_add_metric_card_step2/analytics_add_metric_card_step2_view.dart';
import '../function/analytics/analytics_add/analytics_add_template/analytics_add_metric_card/analytics_add_metric_card_step3/analytics_add_metric_card_step3_view.dart';
import '../function/analytics/analytics_add/analytics_add_template/analytics_add_model/analytics_add_model_view.dart';
import '../function/analytics/analytics_add/analytics_add_template/analytics_add_template_view.dart';
import '../function/analytics/analytics_binding.dart';
import '../function/analytics/analytics_editing/analytics_editing_view.dart';
import '../function/analytics/analytics_entity_list_page/analytics_entity_detail/analytics_entity_detail_view.dart';
import '../function/analytics/analytics_entity_list_page/analytics_entity_detail/order_detail_setting/order_detail_setting_view.dart';
import '../function/analytics/analytics_entity_list_page/analytics_entity_list_view.dart';
import '../function/analytics/analytics_view.dart';
import '../function/launch/launch_view.dart';
import '../function/login/account_manager/account_manager.dart';
import '../function/login/choose_perspective/choose_perspective_view.dart';
import '../function/mine/mine_feedback/mine_feedback_view.dart';
import '../function/mine/mine_setting/mine_setting_account/mine_setting_account_view.dart';
import '../function/mine/mine_setting/mine_setting_target_manage/mine_setting_target_manage_view.dart';
import '../function/mine/mine_setting/mine_setting_target_manage/target_manage_setting/target_manage_setting_view.dart';
import '../function/mine/mine_version/mine_version_view.dart';
import '../function/mine/mine_version/version_update/version_update_view.dart';
import '../widget/analytics/analytics_dining_table_card/dining_table_list/dining_table_list_view.dart';
import '../widget/analytics/analytics_dining_table_card/dining_table_shop_list/dining_table_shop_list_view.dart';
import '../widget/analytics/stores_pk/stores_pk_view.dart';
import '../widget/analytics/target_analysis/target_analysis_view.dart';
import '../widget/web/web_view.dart';

class AppRoutes {
  static String launchPage = '/';
  static String loginPage = '/login_page';
  static String choosePerspectivePage = '/choose_perspective_page';

  static String mainPage = '/main_page';
  static String analyticsPage = '/analytics_page';

  static String analyticsEditingPage = '/analytics_editing_page';
  static String analyticsAddPage = '/analytics_add_page';
  static String singleStoreJumpPage = '/single_store_jump_page';
  static String analyticsAddTemplatePage = '/analytics_add_template_page';
  static String analyticsAddMetricCardStep1Page = '/analytics_add_metric_card_step1_page';
  static String analyticsAddMetricCardStep2Page = '/analytics_add_metric_card_step2_page';
  static String analyticsAddMetricCardStep3Page = '/analytics_add_metric_card_step3_page';
  static String analyticsAddChartPage = '/analytic_add_chart_page';
  static String analyticsAddChartSubViewsMetricPage = '/analytics_add_chart_sub_views_metric_page';
  static String analyticsAddModelPage = '/analytic_add_model_page';

  static String storesPKPage = '/stores_pk_page';

  static String analyticsEntityListPage = '/analytics_entity_list_page';
  static String analyticsEntityDetailPage = '/analytics_entity_Detail_page';
  static String orderDetailSettingPage = '/order_detail_setting_page';

  // 桌台相关
  static String diningTableShopListPage = '/dining_table_shop_list_page';
  static String diningTableListPage = '/dining_table_list_page';

  // 我的相关
  static String minePage = '/mine_page';

  static String mineSettingPage = '/mine_setting_page';
  static String mineSettingAccountPage = '/mine_setting_account_page';
  static String mineSettingThemePage = '/mine_setting_theme_page';
  static String mineSettingLanguagePage = '/mine_setting_language_page';
  static String mineSettingMetricsUnitPage = '/mine_setting_metrics_unit_page';
  static String mineChangeIdentityPage = '/mine_change_identity_page';

  // 目标管理
  static String targetAnalysisPage = '/target_analysis_page';
  static String mineSettingTargetManagePage = '/mine_setting_target_manage_page';
  static String targetManageSettingPage = '/target_manage_setting_page';

  static String mineFeedbackPage = '/mine_feedback_page';
  static String mineVersionPage = '/mine_version_page';
  static String versionUpdatePage = '/version_update_page';

  static String webViewPage = '/web_view_page';

  static String debugToolsPage = '/debug_tools_page';
  static String countryPage = '/country_page';

  static final List<GetPage> routes = [
    GetPage(name: launchPage, page: () => const LaunchPage()),
    // 登录页
    GetPage(name: loginPage, page: () => const LoginPage(), binding: LoginBinding()),
    // 选择视角页
    GetPage(name: choosePerspectivePage, page: () => ChoosePerspectivePage()),

    // tab bar
    GetPage(name: mainPage, page: () => const MainPage(), binding: MainBinding()),
    // AnalyticsPage
    GetPage(name: analyticsPage, page: () => const AnalyticsPage(), binding: AnalyticsBinding()),

    GetPage(name: analyticsEditingPage, page: () => const AnalyticsEditingPage(), popGesture: false),
    GetPage(name: analyticsAddPage, page: () => const AnalyticsAddPage()),
    GetPage(name: singleStoreJumpPage, page: () => const SingleStoreJumpPage()),
    GetPage(name: analyticsAddTemplatePage, page: () => const AnalyticsAddTemplatePage()),
    GetPage(name: analyticsAddMetricCardStep1Page, page: () => const AnalyticsAddMetricCardStep1Page()),
    GetPage(name: analyticsAddMetricCardStep2Page, page: () => const AnalyticsAddMetricCardStep2Page()),
    GetPage(name: analyticsAddMetricCardStep3Page, page: () => const AnalyticsAddMetricCardStep3Page()),
    GetPage(name: analyticsAddChartPage, page: () => const AnalyticsAddChartPage()),
    GetPage(name: analyticsAddChartSubViewsMetricPage, page: () => const AnalyticsAddChartSubViewsMetricPage()),
    GetPage(name: analyticsAddModelPage, page: () => const AnalyticsAddModelPage()),

    // 店铺PK
    GetPage(name: storesPKPage, page: () => const StoresPKPage()),

    GetPage(name: analyticsEntityListPage, page: () => const AnalyticsEntityListPage()),
    GetPage(name: analyticsEntityDetailPage, page: () => const AnalyticsEntityDetailPage()),
    GetPage(name: orderDetailSettingPage, page: () => const OrderDetailSettingPage()),

    // 桌台相关
    GetPage(name: diningTableShopListPage, page: () => const DiningTableShopListPage()),
    GetPage(name: diningTableListPage, page: () => const DiningTableListPage()),

    // Mine
    GetPage(name: minePage, page: () => MinePage(), binding: MineBinding()),
    // Setting
    GetPage(name: mineSettingPage, page: () => const MineSettingPage()),
    GetPage(name: mineSettingAccountPage, page: () => MineSettingAccountPage()),
    GetPage(name: mineSettingThemePage, page: () => MineSettingThemePage()),
    GetPage(name: mineSettingLanguagePage, page: () => MineSettingLanguagePage()),
    GetPage(name: mineSettingMetricsUnitPage, page: () => const MineSettingMetricsUnitPage()),
    GetPage(name: mineChangeIdentityPage, page: () => const RSMineChangeIdentityPage()),

    // 目标管理
    GetPage(name: targetAnalysisPage, page: () => const TargetAnalysisPage()),
    GetPage(name: mineSettingTargetManagePage, page: () => const MineSettingTargetManagePage()),
    GetPage(name: targetManageSettingPage, page: () => const TargetManageSettingPage()),

    // Feedback
    GetPage(name: mineFeedbackPage, page: () => MineFeedbackPage()),
    // Version
    GetPage(name: mineVersionPage, page: () => const MineVersionPage()),
    // 版本更新
    GetPage(name: versionUpdatePage, page: () => const VersionUpdatePage()),
    // 网页
    GetPage(name: webViewPage, page: () => const RSWebViewPage()),
    // Scm页面路由
    ...ScmRoutes.getRoutes(),
  ];

  Widget getPage(String pageName) {
    //没有登录，跳转登录页面
    if (RSAccountManager().userInfoEntity?.accessToken == null) {
      return const LaunchPage();
    }

    // if (pageName == PageNameData.PAGE_ADDDRVICE) {
    //   return AddDevicePage();
    // } else if (pageName == PageNameData.PAGE_DRVICEINFO) {
    //   return DeviceInfoPage();
    // } else if (pageName == PageNameData.PAGE_LOGIN) {
    //   return LoginPage();
    // } else if (pageName == PageNameData.PAGE_ADDDEVICESCANPAGE) {
    //   return AddDeviceScanPage();
    // } else if (pageName == PageNameData.PAGE_SCANQRCODEPAGE) {
    //   return ScanQrCodePage();
    // } else if (pageName == PageNameData.PAGE_MAIN) {
    //   return MainPage();
    // }

    return MainPage();
  }
}
