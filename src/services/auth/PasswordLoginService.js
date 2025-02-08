import BaseService from "../BaseService";

export default class PasswordLoginService extends BaseService {
  /**
   * @description 密码登录
   * @param params
   *  loginName
   *  loginPassword
   * */
  static login(params = {}) {
    return this.request1({ url: `/platform/lgn/login`, params });
  }

  /**
   * @description 验证密码
   * @param params
   *  loginName
   *  loginPassword
   * */
  static checkPassword(params = {}) {
    return this.request1({ url: "/platform/register/checkPwd", params });
  }

  /**
   * 重新设置密码
   * @param params
   * loginName
   * loginPassword
   */
  static lgnResetPwd(params = {}) {
    return this.request1({ url: "/platform/lgn/lgnResetPwd", params });
  }

  /**
   * 重新设置密码
   * @param params
   */
  static resetPwd(params = {}) {
    return this.request1({ url: "/platform/lgn/resetPwd", params });
  }

  /**
   * 忘记密码修改密码
   * @param params
   * loginId
   * loginPassword
   */
  static resetLoginPwd(params = {}) {
    return this.request1({ url: "/platform/lgn/resetLoginPwd", params });
  }

  /**
   * 忘记密码校验短信验证码2
   * @param params
   * telephone
   * code
   */
  static checkPhoneCode(params = {}) {
    return this.request1({ url: "/platform/lgn/checkPhoneCode", params });
  }

  /**
   * 根据原密码修改登录密码
   * @param params
   * loginId
   * oldPwd
   * newPwd
   */
  static resetPasswordByOld(params = {}) {
    return this.request1({ url: "/platform/register/resetLoginPwdByOld", params });
  }
}
