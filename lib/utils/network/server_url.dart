import 'package:flutter_report_project/utils/logger/logger_helper.dart';
import 'package:flutter_report_project/utils/network/app_compile_env.dart';

class RSServerUrl {
  // 私有的构造函数，防止外部实例化
  // RSServerUrl._();

  // 单例实例
  // static RSServerUrl? _instance;

  // 工厂构造函数，用于返回单例实例
  // factory RSServerUrl() {
  //   _instance ??= RSServerUrl._();
  //   return _instance!;
  // }

  /// Base
  static const String _baseUrlUs = 'https://boss-api.us.restosuite.ai';
  static const String _baseUrlEu = 'https://boss-api.eu.restosuite.ai';
  static const String _baseUrlSea = 'https://boss-api.sea.restosuite.ai';
  static const String _baseUrlCn = 'https://boss-api.restosuite.cn';
  static const String _baseUrlTest = 'http://boss-api.test.restosuite.ai';
  static const String _baseUrlUat = 'http://boss-api.uat.restosuite.ai';
  static const String _baseUrlDev = 'http://boss-api.dev.restosuite.ai';

  static String httpBaseUrl = _baseUrlUs;

  // 日志模块
  static const String _baseUploadLogUrlUs = 'https://curiosity-guardian.us.restosuite.ai/guardian/upload';
  static const String _baseUploadLogUrlEu = 'https://curiosity-guardian.eu.restosuite.ai/guardian/upload';
  static const String _baseUploadLogUrlSea = 'https://curiosity-guardian.sea.restosuite.ai/guardian/upload';
  static const String _baseUploadLogUrlCn = 'https://curiosity-guardian.restosuite.cn/guardian/upload';
  static const String _baseUploadLogUrlTest = 'http://curiosity-guardian.test.restosuite.ai/guardian/upload';
  static const String _baseUploadLogUrlUat = 'http://curiosity-guardian.uat.restosuite.ai/guardian/upload';
  static const String _baseUploadLogUrlDev = 'http://curiosity-guardian.dev.restosuite.ai/guardian/upload';

  static String uploadLogBaseUrl = _baseUploadLogUrlUs;

  // app 更新模块
  static const String _baseAppUpgradeUrlUs = 'https://packages.us.restosuite.ai';
  static const String _baseAppUpgradeUrlEu = 'https://packages.eu.restosuite.ai';
  static const String _baseAppUpgradeUrlSea = 'https://packages.sea.restosuite.ai';
  static const String _baseAppUpgradeUrlCn = 'https://packages.restosuite.cn';
  static const String _baseAppUpgradeUrlTest = 'http://packages.test.restosuite.ai';
  static const String _baseAppUpgradeUrlUat = 'http://packages.uat.restosuite.ai';
  static const String _baseAppUpgradeUrlDev = 'http://packages.dev.restosuite.ai';

  static String appUpgradeBaseUrl = _baseAppUpgradeUrlUs;

  /// -----------------------------------------------------------------

  //region App更新相关
  // iOS App Store
  static const String iOSStoreUrl = 'https://itunes.apple.com/app/id6475808945';

  // Android Store
  static const String androidStoreUrl = 'market://details?id=ai.restosuite.inc.insight';

  // 官网——版本更新（支持app内更新）
  static String clientUpgrade = '';

  // 版本更新
  static String checkVersion = '';

  //endregion

  // 隐私协议
  static String appUserPrivacyPolicyUrl = 'https://static.restosuite.cn/privacy/insight_privacy.html';

  //region 用户相关
  /// 登录-区号列表
  static String loginAreaCode = '';

  /// 手机+密码登录
  static String loginByMobileAndPwd = '';

  /// 发送手机验证码
  static String loginSendMobileCaptcha = '';

  /// 手机+验证码登录
  static String loginByMobileAndCaptcha = '';

  /// 邮箱+密码登录
  static String loginByEmailAndPwd = '';

  /// 发送邮箱验证码
  static String loginSendEmailCaptcha = '';

  /// 邮箱+验证码登录
  static String loginByEmailAndCaptcha = '';

  /// 手机号获取Token
  static String loginPhoneGetToken = '';

  /// 邮箱获取Token
  static String loginEmailGetToken = '';

  /// 登出
  static String logout = '';

  /// 切换集团换Token
  static String exchangeToken = '';

  //endregion

  //region 新首页
  /// 获取用户信息
  static String profile = '';

  /// 获取用户模板
  static String userTemplate = '';

  /// 保存用户自定义模板
  static String saveEditUserTemplate = '';

  /// 核心指标
  static String keyMetrics = '';

  /// 趋势分析
  static String periodMetrics = '';

  /// 组成分析
  static String groupMetrics = '';

  /// 异常管理
  static String lossMetrics = '';

  /// 根据tabId 获取自定义和模板信息
  static String tabEditInfo = '';

  /// 根据维度code查询过滤器数据
  static String filtersByDims = '';

  /// 根据根据tabId、cardType 获取卡片自定义信息
  static String cardEditInfo = '';

  /// 用户模板更新tab模板部分
  static String updateTabTemplate = '';

  //endregion

  /// 查询所有主题
  static String getBusinessTopicList = '';

  /// 查询核心指标
  static String getKeyMetrics = '';

  /// 查询异常指标
  static String getLossMetrics = '';

  /// 获取店铺列表
  static String getShops = '';

  /// 组织门店信息
  static String shopOrgInfo = '';

  /// 二级页列表
  static String listTopicEntities = '';

  /// 列表页-查询评价试题列表
  static String listCommentEntities = '';

  /// 列表页-查询可选的维度
  static String getListEntityOptions = '';

  /// 列表页-编辑可选的维度
  static String editListEntityOptions = '';

  /// 查询指标筛选组件数据
  static String getComponentList = '';

  //region 详情页
  /// 订单详情-查询基础信息可选项
  static String getOrderDetailBaseOptions = '';

  /// 订单详情-编辑用户基础信息可选项
  static String editOrderDetailBaseOptions = '';

  /// 订单详情
  static String getOrderDetailPage = '';
  //endregion

  //region 设置模块
  /// 设置——获取用户可配置项
  static String getUserConfig = '';

  /// 设置——编辑用户可配置项
  static String editUserConfig = '';

  //endregion

  //region 店铺PK
  /// 店铺PK——模板
  static String storesPKTemplate = '';

  /// 获取用户【PK】模板
  static String dataPKTemplate = '';

  /// 店铺PK——表格数据
  static String storesPKTableQuery = '';

  /// 异常分析模板——复用PK页
  static String lossMetricsTemplate = '';

  /// 根据指标code查询过滤器数据
  static String filtersByMetrics = '';

  //endregion

  //region 桌台

  /// 桌台-获取门店列表模板
  static String diningTableShopsListTemplate = '';

  /// 桌台-门店列表
  static String diningTableShopsList = '';

  /// 桌台-获取桌台列表模板
  static String diningTableListTemplate = '';

  /// 桌台-桌台列表
  static String diningTableList = '';

  /// 桌台-待结订单详情
  static String diningTablePendingOrderDetail = '';

  /// 桌台-桌台列表过滤条件
  static String diningTableComponentList = '';

  /// AI回复
  static String aiReply = '';

  /// AI欢迎
  static String aiWelcome = '';

  /// AI 反馈信息收集
  static String aiFeedback = '';

  /// AI 解读
  static String aiExplain = '';

  //endregion

  //region 目标管理

  /// 目标管理-获取目标达成页面配置信息
  static String targetManageConfig = '';

  /// 目标管理-目标达成概览页
  static String targetManageOverview = '';

  /// 目标管理-新增目标
  static String targetManageAdd = '';

  /// 目标管理-删除目标
  static String targetManageDelete = '';

  /// 目标管理-修改目标
  static String targetManageUpdate = '';

  /// 目标管理-获取集团下所有目标列表
  static String targetManageListTargets = '';

  /// 目标管理-编辑相关信息 可选指标
  static String targetManageEditConfig = '';

  /// 目标管理-获取配置相关的门店信息
  static String targetManageEditShops = '';

  //endregion

  static void updateBaseUrl() {
    /// 官网——版本更新（支持app内更新）
    clientUpgrade = '$appUpgradeBaseUrl/packages/client/upgrade';

    /// 版本更新
    checkVersion = '$httpBaseUrl/api/boss/config/version';

    //region 登录相关
    /// 登录-区号列表
    loginAreaCode = '$httpBaseUrl/api/boss/user/areaCode';

    /// 手机+密码登录
    loginByMobileAndPwd = '$httpBaseUrl/api/boss/user/loginByMobileAndPwd';

    /// 发送手机验证码
    loginSendMobileCaptcha = '$httpBaseUrl/api/boss/user/sendMobileCaptcha';

    /// 手机+验证码登录
    loginByMobileAndCaptcha = '$httpBaseUrl/api/boss/user/loginByMobileAndCaptcha';

    /// 邮箱+密码登录
    loginByEmailAndPwd = '$httpBaseUrl/api/boss/user/loginByEmailAndPwd';

    /// 发送邮箱验证码
    loginSendEmailCaptcha = '$httpBaseUrl/api/boss/user/sendEmailCaptcha';

    /// 邮箱+验证码登录
    loginByEmailAndCaptcha = '$httpBaseUrl/api/boss/user/loginByEmailAndCaptcha';

    /// 手机号获取Token
    loginPhoneGetToken = '$httpBaseUrl/api/boss/user/mobile';

    /// 邮箱获取Token
    loginEmailGetToken = '$httpBaseUrl/api/boss/user/email';

    /// 登出
    logout = '$httpBaseUrl/api/boss/user/logout';

    /// 切换集团换Token
    exchangeToken = '$httpBaseUrl/api/boss/user/exchangeToken';
    //endregion

    //region 新首页
    /// 获取用户信息
    profile = '$httpBaseUrl/api/boss/user/profile';

    /// 获取用户模板
    userTemplate = '$httpBaseUrl/api/boss/template/get/userTemplate';

    /// 保存用户自定义模板
    saveEditUserTemplate = '$httpBaseUrl/api/boss/template/edit/userTemplate';

    /// 核心指标
    keyMetrics = '$httpBaseUrl/api/boss/data/query/keyMetrics';

    /// 趋势分析
    periodMetrics = '$httpBaseUrl/api/boss/data/query/periodMetrics';

    /// 组成分析
    groupMetrics = '$httpBaseUrl/api/boss/data/query/groupMetrics';

    /// 异常管理
    lossMetrics = '$httpBaseUrl/api/boss/data/query/lossMetrics';

    /// 根据tabId 获取自定义和模板信息
    tabEditInfo = '$httpBaseUrl/api/boss/template/get/tabEditInfo';

    /// 根据维度code查询过滤器数据
    filtersByDims = '$httpBaseUrl/api/boss/component/filtersByDims';

    /// 根据根据tabId、cardType 获取卡片自定义信息
    cardEditInfo = '$httpBaseUrl/api/boss/template/get/cardEditInfo';

    /// 用户模板更新tab模板部分
    updateTabTemplate = '$httpBaseUrl/api/boss/template/edit/updateTabTemplate';

    //endregion

    //region 首页
    /// 查询所有主题
    getBusinessTopicList = '$httpBaseUrl/api/boss/topic/getBusinessTopicList';

    /// 查询核心指标
    getKeyMetrics = '$httpBaseUrl/api/boss/topic/getKeyMetrics';

    /// 查询异常指标
    getLossMetrics = '$httpBaseUrl/api/boss/topic/getLossMetrics';
    //endregion

    //region 门店
    /// 组织门店信息（新）
    shopOrgInfo = '$httpBaseUrl/api/boss/merchant/shopOrgInfos';
    //endregion

    //region 列表页
    /// 二级页列表
    listTopicEntities = '$httpBaseUrl/api/boss/entity/listEntities';

    /// 查询指标筛选组件数据
    getComponentList = '$httpBaseUrl/api/boss/component/listPageComponent';
    //endregion

    /// 订单详情-查询基础信息可选项
    getOrderDetailBaseOptions = '$httpBaseUrl/api/boss/entity/getOrderDetailBaseOptions';

    /// 订单详情-编辑用户基础信息可选项
    editOrderDetailBaseOptions = '$httpBaseUrl/api/boss/entity/editOrderDetailBaseOptions';

    /// 订单详情
    getOrderDetailPage = '$httpBaseUrl/api/boss/entity/getOrderDetailPage';

    /// 查询评价试题列表
    listCommentEntities = '$httpBaseUrl/api/boss/entity/listCommentEntities';

    /// 列表页-查询可选的维度
    getListEntityOptions = '$httpBaseUrl/api/boss/entity/getListEntityOptions';

    /// 列表页-编辑可选的维度
    editListEntityOptions = '$httpBaseUrl/api/boss/entity/editListEntityOptions';

    //region 设置模块
    /// 设置——获取用户可配置项
    getUserConfig = '$httpBaseUrl/api/boss/config/getUserConfig';

    /// 设置——编辑用户可配置项
    editUserConfig = '$httpBaseUrl/api/boss/config/editUserConfig';
    //endregion

    //region 店铺PK
    /// 店铺PK——模板
    storesPKTemplate = '$httpBaseUrl/api/boss/template/get/shopPKTemplate';

    /// 获取用户【PK】模板
    dataPKTemplate = '$httpBaseUrl/api/boss/template/get/dataPKTemplate';

    /// 店铺PK——表格数据
    storesPKTableQuery = '$httpBaseUrl/api/boss/data/query/table';

    /// 异常分析模板——复用PK页
    lossMetricsTemplate = '$httpBaseUrl/api/boss/template/get/lossMetricsTemplate';

    /// 根据指标code查询过滤器数据
    filtersByMetrics = '$httpBaseUrl/api/boss/component/filtersByMetrics';

    //endregion

    //region 桌台

    /// 桌台-获取门店列表模板
    diningTableShopsListTemplate = '$httpBaseUrl/api/boss/table/listShopsTemplate';

    /// 桌台-门店列表
    diningTableShopsList = '$httpBaseUrl/api/boss/table/listShops';

    /// 桌台-获取桌台列表模板
    diningTableListTemplate = '$httpBaseUrl/api/boss/table/listTablesTemplate';

    /// 桌台-桌台列表
    diningTableList = '$httpBaseUrl/api/boss/table/listTables';

    /// 桌台-待结订单详情
    diningTablePendingOrderDetail = '$httpBaseUrl/api/boss/table/pendingOrderDetail';

    /// 桌台-桌台列表过滤条件
    diningTableComponentList = '$httpBaseUrl/api/boss/table/getComponentList';

    /// ai回复
    //aiReply = '$httpBaseUrl/chat'.replaceAll('boss-api.', 'aiinsight.');
    aiReply = '$httpBaseUrl/api/boss/ai/forward/chat';

    /// ai欢迎
    //aiWelcome = httpBaseUrl.replaceAll('boss-api.', 'aiinsight.');
    aiWelcome = '$httpBaseUrl/api/boss/ai/forward';

    /// ai反馈
    aiFeedback = '$httpBaseUrl/api/boss/ai/forward/feedback';
    //aiFeedback = '$httpBaseUrl/api/ai/feedback';

    /// AI 解读
    aiExplain = '$httpBaseUrl/api/ai/explain';

    //endregion

    //region 目标管理

    /// 目标管理-获取目标达成页面配置信息
    targetManageConfig = '$httpBaseUrl/api/boss/achievement/config';

    /// 目标管理-目标达成概览页
    targetManageOverview = '$httpBaseUrl/api/boss/achievement/overview';

    /// 目标管理-新增目标123
    targetManageAdd = '$httpBaseUrl/api/boss/targets/add';

    /// 目标管理-删除目标
    targetManageDelete = '$httpBaseUrl/api/boss/targets/delete';

    /// 目标管理-修改目标
    targetManageUpdate = '$httpBaseUrl/api/boss/targets/update';

    /// 目标管理-获取集团下所有目标列表
    targetManageListTargets = '$httpBaseUrl/api/boss/targets/listTargets';

    /// 目标管理-编辑相关信息 1.可选指标
    targetManageEditConfig = '$httpBaseUrl/api/boss/targets/config';

    /// 目标管理-获取配置相关的门店信息
    targetManageEditShops = '$httpBaseUrl/api/boss/targets/shops';

    //endregion
  }

  /// 初始化域名
  static Future<void> initDomainUrl() async {
    var envType = RSAppCompileEnv.getCurrentEnvType();
    switch (envType) {
      case EnvType.us:
        httpBaseUrl = _baseUrlUs;
        uploadLogBaseUrl = _baseUploadLogUrlUs;
        appUpgradeBaseUrl = _baseAppUpgradeUrlUs;
        break;
      case EnvType.eu:
        httpBaseUrl = _baseUrlEu;
        uploadLogBaseUrl = _baseUploadLogUrlEu;
        appUpgradeBaseUrl = _baseAppUpgradeUrlEu;
        break;
      case EnvType.sea:
        httpBaseUrl = _baseUrlSea;
        uploadLogBaseUrl = _baseUploadLogUrlSea;
        appUpgradeBaseUrl = _baseAppUpgradeUrlSea;
        break;
      case EnvType.test:
        httpBaseUrl = _baseUrlTest;
        uploadLogBaseUrl = _baseUploadLogUrlTest;
        appUpgradeBaseUrl = _baseAppUpgradeUrlTest;
        break;
      case EnvType.uat:
        httpBaseUrl = _baseUrlUat;
        uploadLogBaseUrl = _baseUploadLogUrlUat;
        appUpgradeBaseUrl = _baseAppUpgradeUrlUat;
        break;
      case EnvType.cn:
        httpBaseUrl = _baseUrlCn;
        uploadLogBaseUrl = _baseUploadLogUrlCn;
        appUpgradeBaseUrl = _baseAppUpgradeUrlCn;
        break;
      case EnvType.dev:
        httpBaseUrl = _baseUrlDev;
        uploadLogBaseUrl = _baseUploadLogUrlDev;
        appUpgradeBaseUrl = _baseAppUpgradeUrlDev;
        break;
      default:
        httpBaseUrl = _baseUrlUs;
        uploadLogBaseUrl = _baseUploadLogUrlUs;
        appUpgradeBaseUrl = _baseAppUpgradeUrlUs;
    }

    logger.d("当前环境: $envType --- $httpBaseUrl", StackTrace.current);

    updateBaseUrl();
  }
}
