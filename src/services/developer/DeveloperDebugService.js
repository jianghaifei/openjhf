import BaseService from "../BaseService";

export default class DeveloperDebugService extends BaseService {
  /**
   * @description debug工具请求
   * @params params
   *  type:trace bill order
   */
  static index(params = {}) {
    const url = "/platform/user/queryDebugInfo";
    return this.request1({ url, params });
  }
}
