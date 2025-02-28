import { IKVProps, AxiosRequest } from "@restosuite/bo-common";

// 获取列表
export function getCategoryList(data: any, config?: any): Promise<any> {
  return AxiosRequest.post("/boMenuApi/gql/category/list", data, config);
}
