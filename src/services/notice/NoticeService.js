import BaseService from "../BaseService";

export default class NoticeService extends BaseService {
  /**
   * 获取公告列表
   * @param params
   */
  static index(params = {}) {
    const url = "/platform/msg/queryMsgInfoByUserId";
    return this.request(url, "POST", params);
  }

  /**
   * 获取公告详情
   * @param params
   * id
   */
  static show(params = {}) {
    const url = "/platform/msg/queryMsgDesc";
    return this.request(url, "POST", params);
  }
}
