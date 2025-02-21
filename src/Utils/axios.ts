/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import axios, {
    AxiosResponse,
    AxiosError,
    AxiosRequestConfig,
    AxiosPromise,
  } from "axios";
// import { v4 as uuid } from "uuid";
import { IApiResult } from "../Model/IApiResult";
  
  axios.defaults.timeout = 60000;
  
  //创建axios请求实例
  const serviceAxios = axios.create({
    // baseURL: ""
    timeout: 60000,
    withCredentials: true, //跨域是否携带cookie
  });
  
  //request拦截器
  serviceAxios.interceptors.request.use(
    (config) => {
      //添加token
      // config.headers["Authorization"] = localStorage.getItem("token")
  
      // traceID 单个请求唯一标识，后端日志可追踪

      // config.headers["traceId"] = uuid();

      // config.headers["crossDomain"] = true;
      // // eslint-disable-next-line @typescript-eslint/no-unused-expressions
      // config.headers.common["common['Access-Control-Allow-Origin']"] = '*';
  
      //   // 设置请求头
      if (!config.headers["content-type"]) {
        config.headers["content-type"] = "application/json";
      }
      return config;
    },
    (error) => {
      // eslint-disable-next-line @typescript-eslint/no-floating-promises
      Promise.reject(error);
    }
  );
  
  // 返回拦截
  serviceAxios.interceptors.response.use(
    (res: AxiosResponse) => {
      // TODO: 错误拦截，提示，跳转
      if (res.status === 200) {
        if (res.data == null) {
          return Promise.resolve({
            code: "-1",
            data: null,
            message: "service return null data",
          });
        }
        return Promise.resolve(res.data);
      }
      return Promise.resolve({
        code: "701",
        data: null,
        message: "unknown network error!",
      });
    },
    (err: AxiosError) => {
      // 请求错误提示语
      let errMsg = "unknown network error!";
      if (err && err.response) {
        const { status } = err.response;
        switch (status) {
          case 400:
            errMsg = "错误请求";
            break;
          case 401:
            errMsg = "未授权，请重新登录";
            break;
          case 403:
            errMsg = "拒绝访问";
            break;
          case 404:
            errMsg = "请求错误，未找到该资源";
            break;
          case 405:
            errMsg = "请求方法未允许";
            break;
          case 408:
            errMsg = "请求超时";
            break;
          case 500:
            errMsg = "服务器端出错";
            break;
          case 501:
            errMsg = "网络未实现";
            break;
          case 502:
            errMsg = "网络错误";
            break;
          case 503:
            errMsg = "服务不可用";
            break;
          case 504:
            errMsg = "网络超时";
            break;
          case 505:
            errMsg = "http版本不支持该请求";
            break;
          default:
            errMsg = `连接错误${status}`;
        }
      }
  
      if (!window.navigator.onLine) {
        errMsg = "网络连接已断开，请检测网络连接情况";
      }
      return Promise.reject(errMsg);
    }
  );
  
  const requestEntry = (promise: AxiosPromise<IApiResult<any>>) => {
    return promise.then((r: any) => {
      if (r.code === "000") {
        return Promise.resolve(r);
      } else {
        return Promise.resolve(r);
      }
    });
  };
  
  /**
   * get
   * @param url
   * @param params
   * @param config
   * @returns {Promise}
   */
  const get = (
    url: string,
    params?: any,
    config?: AxiosRequestConfig
  ): Promise<IApiResult<any>> => {
    return requestEntry(serviceAxios.get(url, { params, ...config }));
  };
  
  /**
   * post
   * @param url
   * @param data
   * @param config
   * @returns {Promise}
   */
  const post = (
    url: string,
    data?: any,
    config?: AxiosRequestConfig
  ): Promise<IApiResult<any>> => {
    return requestEntry(serviceAxios.post(url, data, config));
  };
  
  const AxiosRequest = {
    get,
    post,
  };
  
  export default AxiosRequest;
  