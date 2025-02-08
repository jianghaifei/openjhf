import BaseService from "../BaseService";

export default class SearchService extends BaseService {
  /**
   * 根据关键字获取选中内容明细高亮显示
   * @param params
   * parentNavId
   * keyWord
   * pageNo
   * pageSize
   */
  static queryContentByKeyWordsHL(params = {}) {
    const url = "/platform/search/queryContentByKeyWordsHL";
    return this.request(url, "POST", params);
  }

  /**
   * 根据关键字获取选中总数
   * @param params
   * keyWord
   */
  static queryCountByKeyWord(params = {}) {
    const url = "/platform/search/queryCountByKeyWord";
    return this.request(url, "POST", params);
  }
}
