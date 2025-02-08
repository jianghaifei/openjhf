import BaseService from "../BaseService";

export default class RegisterService extends BaseService {
  /**
   * 注册账户
   * @param params
   * loginName
   * loginPwd
   * identifyCode
   * telephone
   */

  static register(params = {}) {
    return this.request1({ url: "/platform/register/add", params });
  }
}
