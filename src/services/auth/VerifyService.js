import BaseService from "../BaseService";

export default class VerifyService extends BaseService {
  /**
   * 判断用户是否实名认证
   * @param params
   */
  static userStatus(params = {}) {
    const url = "/platform/lgn/checkUserStatus";
    return this.request1({ url, params });
  }

  /**
   * 判断用户是否存在
   * @param params
   * loginName
   */
  static verifyLoginName(params = {}) {
    const url = "/platform/register/queryLoginName";
    return this.request1({ url, params });
  }

  /**
   * 验证身份证反面信息
   * @param params
   * backFile
   */
  static verifyIDCardBackInfo(params = {}) {
    const url = "/platform/register/lgnQueryIDCardBackInfo";
    return this.request1({ url, params });
  }

  /**
   * 验证身份证正面信息
   * @param params
   * faceFile
   */
  static verifyIDCardFaceInfo(params = {}) {
    const url = "/platform/register/lgnQueryIDCardFaceInfo";
    return this.request1({ url, params });
  }

  /**
   * 验证营业执照信息
   * @param params
   * licenseFile
   */
  static verifyLicenseInfo(params = {}) {
    const url = "/platform/register/lgnQueryLicenseInfo";
    return this.request1({ url, params });
  }
}
