import { IPageMeta, } from "@restosuite/field-core";
import { PageMetaUtils } from "@restosuite/bo-common"
import _ from "lodash";
import { asyncGetPageMetaUtils as RSAsyncGetPageMetaUtils } from "@restosuite/fe-skeleton"
// 获取页面配置 - 前期不放在服务器, 以后放服务器的时候再做同步异步
export const getPageMeta = (page_id: string): IPageMeta | null => {

  // zlj增加，为了能够动态注册加载供应链元数据
  if ((window as any).dynamicPageModules) {
    const module = (window as any).dynamicPageModules[page_id];
    if (module) {
      return module
    }
  }
  // return _.get(pageModules, page_id) || null;
};

// 异步
export const asyncGetPageMetaUtils = (
  page_id: string
): Promise<PageMetaUtils> => {
  const originPageMeta = getPageMeta(page_id);
  return RSAsyncGetPageMetaUtils(page_id, originPageMeta)
};
