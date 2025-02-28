import { IKVProps } from "@restosuite/field-core";
import AxiosRequest from "@src/Utils/axios";

export function getMenuTree(params: IKVProps, config?: any): Promise<any> {
  return AxiosRequest.post("/boMenuApi/api/menu/tree", params, config);
}