import BaseService from "../BaseService";

export default class ResourceMenuService extends BaseService {
  /**
   * 获取所有开放平台前台导航菜单
   * @param classify 3 帮助中心 4 文档中心
   * naviType
   */
  static index(classify) {
    const url = "/platform/helpCenter/findByClassify";
    return this.request1({ url, params: { classify } });
  }
}
