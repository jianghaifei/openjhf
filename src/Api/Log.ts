import AxiosRequest from "@src/Utils/axios";

// 获取登录日志
export function getLoginListPage(data: any): Promise<any> {
  return AxiosRequest.post("/eventTracking/loginListPage", data);
}

// 获取操作日志
export function getOperatingListPage(data: any): Promise<any> {
  return AxiosRequest.post("/eventTracking/listPage", data);
}

// 获取门店列表
export function getStoreList(data: any): Promise<any> {
  return AxiosRequest.post("/boShopApi/api/shop/simpleListQuery", data);
}