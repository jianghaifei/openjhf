import AxiosRequest from "@src/Utils/axios";

// 查询分类映射-查询默认分类用
export function categoryMapping(data: any): Promise<any> {
    return AxiosRequest.post("/otd/manage/trd/category/mapping", data);
}

// 查询三方菜品
export function trdItemQuery(data: any): Promise<any> {
    return AxiosRequest.post("/otd/manage/trd/item/query", data);
}

// 更新商品映射
export function categoryMap(data: any): Promise<any> {
    return AxiosRequest.post("/otd/manage/trd/category/map", data);
}

// 查询我方菜品
export function itemQuery(data: any): Promise<any> {
    return AxiosRequest.post("/otd/manage/menu/item/query", data);
}

// 更新商品映射
export function itemMap(data: any): Promise<any> {
    return AxiosRequest.post("/otd/manage/trd/item/map", data);
}

// 批量上下架
export function itemSwitch(data: any): Promise<any> {
    return AxiosRequest.post("/otd/manage/trd/item/switch", data);
}

// 同步三方商品
export function itemPull(data: any): Promise<any> {
    return AxiosRequest.post("/otd/manage/trd/item/pull", data);
}

// 复制菜品映射
export function mappingCopy(data: any): Promise<any> {
    return AxiosRequest.post("/otd/manage/trd/item/mapping/copy", data);
}
