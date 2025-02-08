import BaseService from "../BaseService";

export default class UserService extends BaseService {
  /**
   * 获取用户信息
   * @param params
   */
  static show(params = {}) {
    const url = "/platform/lgn/queryUserInfoByToken";
    return this.request(url, "POST", params);
  }

  /**
   * 查询实名认证用户信息
   * @param params
   * loginId
   */
  static show1(params = {}) {
    const url = "/platform/register/queryUserInfo";
    return this.request(url, "POST", params);
  }

  /**
   * 修改名称
   * @param params
   * loginId
   * loginName
   */
  static resetLoginName(params = {}) {
    const url = "/platform/register/resetLoginName";
    return this.request(url, "POST", params);
  }

  /**
   * 实名认证提交
   * @param params
   */
  static sendUserInfo(params = {}) {
    const url = "/platform/register/submitUserInfo";
    return this.request(url, "POST", params);
  }

  /**
   * 提交开发者信息
   * @param params
   * originalId
   * loginId
   * userType
   * businessLicensePath
   */
  static sendDeveloperInfo(params = {}) {
    const url = "/platform/register/lgnPersonalApply";
    return this.request(url, "POST", params);
  }
}
