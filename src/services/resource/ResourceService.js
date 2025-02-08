import BaseService from "../BaseService";

export default class ResourceService extends BaseService {
  // todo 目前只有帮助中心使用 固定写死classify为3
  static index(id, isNew) {
    return this.request1({
      url: "/platform/helpCenter/queryNaviIdList",
      data: {
        id: Number(id),
        isNew: Number(isNew),
        classify: 3,
        status: 1
      }
    });
  }

  static show(id, classify) {
    return this.request1({
      url: "/platform/helpCenter/findByNaviIdNew",
      params: { id, classify }
    });
  }

  static search(data) {
    return this.request1({
      url: "/platform/helpCenter/queryNaviIdListByKeywords",
      data
    });
  }
}
