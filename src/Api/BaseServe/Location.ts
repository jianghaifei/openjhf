import { IKVProps } from "@restosuite/field-core";
import AxiosRequest from "@src/Utils/axios";

export const getLocationList = (params: any): Promise<any> => {
  return AxiosRequest.post("/boShopApi/api/shop/pageQuery", params);
};
