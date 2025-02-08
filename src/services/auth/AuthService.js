import BaseService from "../BaseService";

export default class AuthService extends BaseService {
  /**
   * 发送短信验证码
   * @param params
   * telephone
   */
  static sendVerificationCode(params = {}) {
    return this.request1({ url: "/platform/lgn/sendCheckCode", params });
  }

  /**
   * 登出
   * @param params
   */
  static loginOut(params = {}) {
    return this.request1({ url: "/platform/lgn/loginOut", params });
  }

  /**
   * 二期接口
   * 获取滑块验证码的图片
   * @param params
   */
  static getCheckCodeImg(params = {}) {
    return this.request1({ url: "/platform/lgn/getCheckCodeImg", params });
  }

  /**
   * 滑块验证
   * @param params
   * width
   */
  static checkImg(params = {}) {
    return this.request1({ url: "/platform/lgn/checkImg", params });
  }

  /**
   * 开发者秘钥重置·新
   * @param params
   * platUserId
   */
  static resetAppSecret(params = {}) {
    return this.request1({ url: "/platform/register/resetAppSecret", params });
  }
}
