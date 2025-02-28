import AxiosRequest from "@src/Utils/axios";

// 可用的平台列表
export function platformList(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/platform/activatedList", data);
}
// 获取授权店铺列表
export function getAuthList(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/getAuthList", data);
}
// 查询店铺授权信息列表
export function queryShopAuthList(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/queryShopAuthList", data);
}
// 申请授权店铺
export function requestAuth(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/requestAuth", data);
}
// 申请授权商户
export function merchantRequestAuth(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/requestAuth", data);
}
// 获取授权店铺信息
export function getAuth(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/getAuth", data);
}
// 解除授权店铺
export function removeAuth(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/removeAuth", data);
}
// 操作店铺
export function operate(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/operate", data);
}
// 查询店铺绑定的外卖菜单
export function queryBindMenu(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/item/queryBindMenu", data);
}
// 选择外卖菜单/切换外卖菜单
export function bindMenu(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/item/bindMenu", data);
}
// 查询我方商品、绑定关系、关联三方商品 + 商品状态
export function queryItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/item/queryItems", data);
}
// 未绑定商品查询
export function queryUnBindItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/item/queryUnBindItems", data);
}
// 发布菜单
export function publishMenuItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/item/publishMenuItems", data);
}
// 批量上架\批量下架
export function batchItemStatus(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/item/batchItemStatus", data);
}
// 发布记录
export function queryPublishHistory(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/publish/queryPublishHistory", data);
}
// 发布详情
export function queryPublishDetail(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/publish/queryPublishDetail", data);
}
// 发布结果详情查询
export function queryPublishResult(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/publish/queryPublishResult", data);
}
// 获取商户授权信息
export function merchantGetAuth(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/getAuth", data);
}
// 获取商户下的店铺列表
export function getShopList(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/getShopList", data);
}
// 确认店铺授权（关联店铺）
export function applyShopAuth(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/applyShopAuth", data);
}
// 解除授权商户
export function merchantRemoveAuth(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/removeAuth", data);
}
// ub 菜品绑定列表
export function upItemBindingList(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/menu/itemBindingList", data);
}
// ub 菜品批量上下架
export function upBatchItemStatus(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/menu/batchItemStatus", data);
}
// ub 菜单发布
export function upPublish(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/menu/publish", data);
}
// ub 未绑定的菜品列表
export function ubQueryUnBindItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/menu/queryUnBindItems", data);
}
// 曾经发布过的菜单的查询
export function queryPublishMenuList(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/hp/publish/queryPublishMenuList", data);
}
// 查询三放平台配置(下拉框层级结构)
export function threeLevelLinkageQuery(params?: any) {
  return AxiosRequest.post(
    "/operation-manager/thirdConfiguration/threeLevelLinkageQuery",
    params
  );
}
// 查询eleme我方商品、绑定关系、关联三方商品
export function elemeQueryItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/page/items", data);
}
// 批量\单个 上下架
export function elemeBatchItemStatus(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/shelf", data);
}
// 全量查未绑定商品
export function elemeQueryUnbindItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/list/trd/unbindItems", data);
}
// 全量查询我方菜单菜品及关联菜品
export function elemeSelfItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/list/selfItems", data);
}

// 全量查三方菜品
export function elemeTrdItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/list/trd/items", data);
}
// 单个\批量绑定
export function elemeBindItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/bind", data);
}
// 单个\批量解绑
export function elemeUnbindItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/unbind", data);
}

// 分页查未绑定商品
export function elemeQueryPageUnbindItems(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/page/trd/unbindItems", data);
}
// 同步第三方商品
export function batchUpdateTrdItem(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/domestic/item/batchUpdate/trd/item", data);
}

// 餐道-取消授权-移除店铺
export function channelAutharemoveMerchant(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/removeMerchant", data);
}

// 获取省市县
export function getListArea(data: any): Promise<any> {
  return AxiosRequest.post("/operation-manager/dictionary/listArea", data);
}

// 查询操作结果
export function queryOptionResult(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/urbanPiper/queryOptionResult", data);
}


// 获取多通道授权模式-商户
export function merchantlistMerchant(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/listMerchant", data);
}

// 获取多通道授权模式-门店
export function merchantChannelsForAddShop(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/channelsForAddShop", data);
}

// 多通道列表
export function shopPageShop(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/pageShop", data);
}

// 新授权接口 creatable 获取授权信息
export function newAddMerchant(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/addMerchant", data);
}

// 商户下店铺列表
export function merchantShops(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/merchantShops", data);
}

// 从商户添加店铺  merchants 获取授权信息
export function addShopFromMerchant(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/addShopFromMerchant", data);
}

// 餐道-授权-添加店铺 system 获取授权信息
export function channelAuthaddShop(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/addShop", data);
}

// new 移除店铺接口
export function newRemoveShop(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/removeShop", data);
}

// new 解除商户授权
export function newRemoveAuth(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/removeAuth", data);
}

// 绑定店铺轮训
export function newGetShop(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/getShop", data);
}

// 授权商户与授权商户轮训
export function newGetMerchant(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/merchant/getMerchant", data);
}

// 新版getauth接口
export function shopQueryShop(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/queryShop", data);
}

// 新切换菜单接口
export function changeOperateShop(data: any): Promise<any> {
  return AxiosRequest.post("/channel-auth/shop/operateShop", data);
}

// 
export function unmapTrdItem(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/mapping/item/unmapTrdItem", data);
}

// grab 获取查询发布状态接口
export function newQueryPublishResult(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/menu/queryPublishResult", data);
}

// keeta 发布接口
export function keetaTrditemPublish(data: any): Promise<any> {
  return AxiosRequest.post("/otd/manage/trd/item/publish", data);
}