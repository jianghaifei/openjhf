import { IKVProps } from "@restosuite/field-core";
import AxiosRequest from "@src/Utils/axios";

// 获取当前用户下的授权范围
export function queryShopListByEmployeeId(data: IKVProps): Promise<IKVProps> {
  return AxiosRequest.post(
    "/vulcan/permission/queryPermissionList",
    data
  );
}