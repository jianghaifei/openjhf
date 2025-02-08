import BaseService from "../BaseService";

export default class TelephoneLoginService extends BaseService {
  /**
   * 手机号登录
   * @param params
   */
  static loginByTelephone(params = {}) {
    return this.request1({ url: "/platform/lgn/loginByPhoneNum", params });
  }

  /**
   * 根据手机号验证
   * @param params
   * telephone
   */
  static queryPhone(params = {}) {
    return this.request1({ url: "/platform/lgn/queryPhone", params });
  }

  /**
   * 验证验证码
   * @param params
   * code
   */
  static checkCode(params = {}) {
    return this.request1({ url: "/platform/lgn/checkCode", params });
  }

  /**
   * 修改手机号验证码校验
   * @param params
   * loginId
   * identifyCode
   * phoneNum
   */
  static resetPhone(params = {}) {
    return this.request1({ url: "/platform/register/resetPhone", params });
  }
}
