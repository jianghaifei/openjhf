import AxiosRequest from "@src/Utils/axios";

// 获取规则列表
export function deliveryQuery(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/delivery/query", data);
}

// 新增规则配置
export function deliverySave(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/delivery/save", data);
}

// 修改规则配置
export function deliveryUpdate(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/delivery/update", data);
}

// 移除规则配置（归档）
export function deliveryRemove(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/delivery/remove", data);
}

// 获取规则详情
export function deliveryQueryDetail(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/delivery/queryDetail", data);
}

// 门店规则配置列表
export function deliveryQueryConfigs(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/delivery/queryConfigs", data);
}

// 门店规则-设置规则
export function deliverySaveConfigs(data: any): Promise<any> {
  return AxiosRequest.post("otd/manage/delivery/saveConfigs", data);
}

// 门店规则-取消设置
export function deliveryRemoveConfigs(data: any): Promise<any> {
  return AxiosRequest.post("otd/manage/delivery/removeConfigs", data);
}

// 获取通道
export function deliveryAuthedChannelList(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/delivery/authedChannelList", data);
}

// 获取通道
export function shopQueryChannelShopInfo(data: any): Promise<any> {
  return AxiosRequest.post("channel-auth/shop/queryChannelShopInfo", data);
}
