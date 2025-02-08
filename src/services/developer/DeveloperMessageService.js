import BaseService from "../BaseService";

export default class DeveloperMessageService extends BaseService {
  static index(params = {}) {
    const url = "/platform/user/alert/list";
    return this.request1({ url, params });
  }

  /**
   * @description 保存配置或发送测试消息
   * @param params
   * 	opt 类型 string<sendMsg | setConfig>
   * 	channel 渠道 string
   * 	webhook hook地址 string
   * 	msg? 消息 string
   */
  static save(params = {}) {
    const url = "/platform/user/alert/config";
    return this.request1({ url, params });
  }

  /**
   * @description 激活授权
   * @param params
   * 	appKey
   */
  static auth(params = {}) {
    const url = "/platform/user/alert/auth";
    return this.request1({ url, params });
  }
}
