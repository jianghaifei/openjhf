import BaseService from "../BaseService";

export default class NoticeTypeService extends BaseService {
  /**
   * 获取公告类型列表
   * @param params
   */
  static index(params = {}) {
    const url = "/platform/msg/queryMsgTypeInfo";
    return this.request(url, "POST", params);
  }
}
