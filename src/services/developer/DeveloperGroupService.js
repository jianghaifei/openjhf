import BaseService from "../BaseService";

export default class DeveloperGroupService extends BaseService {
  /**
   * 获取集团列表
   * @param params
   * userId 用户id
   */
  static index(params = {}) {
    return this.request1({
      url: "/platform/user/queryBindGroupIdInfo",
      params
    });
  }

  /**
   * 获取集团详情
   * @param params
   * platUserId 用户id
   * merUserId
   */
  static show(params = {}) {
    return this.request1({ url: "/platform/user/platBindDetail", params });
  }
}
