import { nanoid } from "nanoid";
import Http from "./Http";

export default class BaseService {
  static request(url, method, params = {}, options = { type: "params" }) {
    const obj = {
      url,
      method
    };
    obj[options.type === "params" ? "params" : "data"] = this.filterParams(params);
    return Http(obj);
  }

  static request1(options = {}) {
    const { url, method, params, data, traceId = true } = options;
    const httpOptions = { url, method: method || "POST" };
    if ("params" in options) {
      httpOptions.params = this.filterParams(params, traceId);
    }
    if ("data" in options) {
      httpOptions.data = this.filterParams(data, traceId);
    }
    return Http(httpOptions);
  }

  static filterParams(params, isAdd = true) {
    if (!isAdd) return params;
    if (typeof params === "string") {
      try {
        const paramsObj = JSON.parse(params);
        paramsObj.traceId = nanoid();
        return JSON.stringify(paramsObj);
      } catch (e) {
        return params;
      }
    }
    if (typeof params === "object")
      return {
        ...params,
        traceId: nanoid()
      };
  }
}
