import BaseService from "./BaseService";

export default class IndexService extends BaseService {
  /**
   * @description 获取首页跳转所需的枚举数据
   * */
  static getIndexData(params = {}) {
    const url = `platform/lgn/showIndexData`;
    return this.request(url, "POST", params);
  }
}
