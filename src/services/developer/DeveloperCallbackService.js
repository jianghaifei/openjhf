import BaseService from "../BaseService";

export default class DeveloperCallbackService extends BaseService {
  static save(data = {}) {
    return this.request1({
      url: "/platform/user/updateOrCreateNotify",
      data
    });
  }

  static delete(id) {
    return this.request1({
      url: "/platform/user/deleteNotify",
      data: { notifyId: id }
    });
  }

  static verify(url, type) {
    return this.request1({
      url: "/platform/user/testCheckNotifyAddr",
      data: {
        addr: url,
        type
      }
    });
  }

  static refresh(data = {}) {
    return this.request1({
      url: "/platform/user/queryCallbackDetail",
      data
    });
  }
}
