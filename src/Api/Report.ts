import AxiosRequest from "@src/Utils/axios";
import FieldEnumUtils from "@src/Utils/FieldEnumUtils";
import { func } from "prop-types";

// 获取列元数据
export function reportMetadata(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/metadata/get", data);
}
// 获取对比数据
export function quaryDataCompTo(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/data/queryData", data);
}
// TimeSales折线图获取对比数据
export function getCompData(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/data/periodMetrics", data);
}
// 获取报表汇总
export function reportTotalsData(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/data/summary", data);
}
// 查询业务维度的选项
export function getBusinessDimOptions(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/dim/getDimOptions", data);
}
// 报表导出
export function exportExcel(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/data/exportExcel", data, {
    responseType: "blob",
    headers: {}
  });
}
// 获取业务对象

export function getManagerFieldEnum(id: string): Promise<any> {
  return FieldEnumUtils(AxiosRequest.post("/operation-manager/object/field/enum/metadata/listFieldEnumValue", {
    code: id
  }));
}
// order detail详情接口
export function orderDetail(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/entity/getOrderDetail", data);
}
// 查询订单详情页
export function getOrderDetailPage(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/entity/getOrderDetailPage", data);
}
// 报表首页下面的block数据
export function getDataBlock(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/data/dataBlock", data);
}
// 获取block topic list 数据
export function getBlockTopic(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/metadata/blockTable", data);
}
// 获取block topic table数据
export function getTopicBlockTable(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/data/dataBlockTable", data);
}

// 获取货币符号下拉框数据
export function getCurrencyOptions(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/dim/getCurrencyOptions", data);
}

// 保存报表方案
export function savePlan(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/queryplan/savePlan", data);
}

// 获取报表方案列表
export function getPlanList(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/queryplan/listPlan", data);
}

// 批量保存计划
export function batchSavePlan(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/queryplan/saveAllPlan", data);
}

// 查询报表动态二级表头
export function getDynamicSubHead(data: any): Promise<any> {
  return AxiosRequest.post("/api/report/metadata/getDynamicSubHead", data);
}

// 查询门店信息
export function getReportShopFilters(data: any): Promise<any> {
  return AxiosRequest.post(
    "/api/report/merchant/getReportShopFilters",
    data
  );
}