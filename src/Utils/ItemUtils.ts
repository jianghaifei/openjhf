import { IKVProps } from "@restosuite/fe-sdk";
import { rootStore } from "@src/Store";

// 集团菜单涉及到很多基本档业务接口都需要传品牌相关数据
// 这里写一个header 视角参数容器包裹, 统一进行处理
// 支持子页面传父页面的 pathname 做复用

type IExtraParams = {
    excludeCorpId?: boolean
}
export const ItemBrandParamsWrapper = (pathname?: string, returnParams = false, customBrandId?: string | null, extraParams: IExtraParams = {
    excludeCorpId: false
}) => {
    const { loginStore, bizStore } = rootStore
    const userinfo = loginStore.getUserInfo()

    const corpId = userinfo?.corporationId
    // 支持外部传入品牌 Id,有一些跨页面的情况,需要使用来源页面的品牌 ID
    const memoryBrandId = customBrandId || bizStore.getListBrandId(getItemBrandMemoryKey(pathname));
    let memoryBrandName = bizStore.getListBrandName(getItemBrandMemoryKey(pathname));

    // 如果传入了自定义品牌 id, 将品牌名也改一下
    if (customBrandId) {
        const brandInfo = loginStore.getOrgViewInfo?.()?.[1];
        if (brandInfo && brandInfo?.data) {
            const targetBrand =
                brandInfo?.data?.find?.((o: IKVProps) => o.orgId === customBrandId)
            if (targetBrand) {
                memoryBrandName = targetBrand?.orgName
            }
        }
    }


    // 集团视角,选择了某个品牌时,拼接品牌参数  (且下拉选择的不是"集团"或者"全部")
    if (userinfo?.orgType === "0" && !([extraParams?.excludeCorpId ? null : corpId, "-1"].includes(memoryBrandId)) && memoryBrandId) {
        if (returnParams) {
            return {
                brandId: memoryBrandId,
                orgType: "1",
                orgId: memoryBrandId,
                brandName: memoryBrandName
            }
        }
        return {
            customHeaders: {
                ["Brand-Id"]: memoryBrandId,
                ["Organization-Id"]: memoryBrandId,
                ["Organization-type"]: "1",
            },
        }
    }

    if (returnParams) {
        return {}
    }
    // 默认不覆盖
    return {
        customHeaders: {},
    }

}

export const getItemBrandMemoryKey = (pathname?: string) => {
    const { loginStore } = rootStore
    const userinfo = loginStore.getUserInfo()
    if (!userinfo) {
        return ""
    }
    return `${pathname || location.pathname}_${userinfo.orgId}`;
}