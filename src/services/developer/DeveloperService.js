import BaseService from "../BaseService";

export default class DeveloperService extends BaseService {
  /**
   *开发者秘钥重置
   * @param params
   * devId
   */
  static lgnResetDevPwd(params = {}) {
    const url = "/platform/user/lgnResetDevPwd";
    return this.request(url, "POST", params);
  }

  /**
   *商户绑定页面查询详情
   * @param params
   * orderNo
   * oldPwd
   * newPwd
   */
  static lgnQueryApplyInfoDetail(params = {}) {
    const url = "/platform/user/lgnQueryApplyInfoDetail";
    return this.request(url, "POST", params);
  }

  /**
   *签名生成接口
   * @param params
   * json
   * secret
   */
  static lgnSign(params = {}) {
    const url = "/platform/user/lgnSign";
    return this.request(url, "POST", params, { type: "data" });
  }

  /**
   *解密接口
   * @param params
   * text
   * secret
   */
  static lgnAESDncode(params = {}) {
    const url = "/platform/user/lgnAESDncode";
    return this.request(url, "POST", params, { type: "data" });
  }

  /**
   *开发者申请绑定列表条件查询
   * @param params
   *userId 用户id
   *authorityStatus 授权状态
   */
  static getGroupApplyRecord(params = {}) {
    const url = "/platform/user/queryPlatApplyBinds";
    return this.request(url, "POST", params);
  }

  /**
   *开发者提交申请绑定·新
   * @param params
   * userId
   * groupId
   */
  static platUserBind(params = {}) {
    const url = "/platform/user/platUserBind";
    return this.request(url, "POST", params);
  }

  /**
   *查询绑定申请详情·新
   * @param params
   * orderNo
   */
  static queryBindDetail(params = {}) {
    const url = "/platform/user/queryBindDetail";
    return this.request(url, "POST", params);
  }

  /**
   * 删除绑定失败数据记录·新
   * @param params
   * orderNo
   */
  static deleteFailBind(params = {}) {
    const url = "/platform/user/deleteFailBind";
    return this.request(url, "POST", params);
  }

  /**
   * 查询授权接口设置的店铺列表
   * @param params
   */
  static queryAuthShops(params = {}) {
    const url = "/platform/user/queryAuthShops";
    return this.request(url, "POST", params);
  }

  static confirmProtocol(params = {}) {
    const url = "/platform/user/confirmProtocol";
    return this.request(url, "POST", params);
  }
}
