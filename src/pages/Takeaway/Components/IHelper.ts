import { t } from "i18next"
import { message, Tooltip } from "antd";
import { getCurrencySymbol } from "@src/Utils/CommonUtils";
import {
    queryItems,
    upItemBindingList,
    elemeQueryItems,
    elemeQueryPageUnbindItems,
} from "@src/Api/Takeaway/StoreAndItems";
import { itemQuery, itemMap } from "@src/Api/Takeaway/takeoutDelivery";


// 是urbanPiper通道的，用来判断使用同一种交互逻辑
export const UrbanPiperList = ["uberEats", "doorDash", "justEat"]


export const shopTitle: any = {
    "meituan": t("instant.MEITUAN", { ns: "Takeaway" }),// 美团
    "meituanMerchant": t("instant.MEITUANBrand", { ns: "Takeaway" }),// "美团品牌商",
    "eleme": t("instant.ELA", { ns: "Takeaway" }),//"饿了么",
    "elemeMerchant": t("instant.ELABrand", { ns: "Takeaway" }),//"饿了么品牌商",
    "douyin": t("instant.DOBU", { ns: "Takeaway" }),//"抖音",
    "douyinMerchant": t("instant.DOBUBrand", { ns: "Takeaway" }),//"抖音品牌商",
    "hungryPanda": t("instant.Panda", { ns: "Takeaway" }),//"熊猫外卖",
    "candao": t("instant.CANDAO", { ns: "Takeaway" }),//"餐道",
    "miaoti": t("instant.MiaoTi", { ns: "Takeaway" }),// 秒提
    "meituanmiaoti": t("instant.MEITUANMiaoTi", { ns: "Takeaway" }),// 美团秒提
    "uberEats": "Uber Eats",
    "justEat": "Just Eat",
    "doorDash": "DoorDash",
    "DoorDash": "DoorDash"
}


export const unbingKey = [
    "groupName",
    "trdItemId",
    "trdItemName",
    "trdPrice",
    "trdSkuId",
    "trdItemSizeName",
    "trdPosItemId",
];
export const FilterKeys = [
    "menuGroupName",
    "itemId",
    "skuId",
    "itemType",
    "itemName",
    "itemSizeName",
    "groupName",
    "trdItemName",
    "trdItemSizeName",
    "trdSubMenuName",
];


// 获取商品映射主列表数据
// 多个人写的前后端代码，类型、渠道不同，接口不同，封装进行统一整理
export const getMapdata = (queryData?: any, callback?: any, catchCallback?: any) => {
    const resSetData = (res: any) => {
        const { code, data } = res;
        if (code != "000") {
            callback({
                code,
            })
        }
        const { itemRelations = [], notBindCount } = data;
        const currencySymbol = getCurrencySymbol();
        try {
            const newList = itemRelations.map((item: any, index: number) => {
                const newItem: any = {
                    index: index + 1,
                    ...item,
                };
                // eleme 和 美团 一个交互流程

                if (situationsCheck(queryData?.channel, "inSide", [], ["keeta"])) {
                    newItem.bindStatusValue = item?.trdItems && item?.trdItems !== "-" && item?.trdItems.length > 0 ? "1" : "0";
                    newItem.bindStatus =
                        item?.trdItems && item?.trdItems !== "-" && item?.trdItems.length > 0
                            ? t("product.bindStatusYes", { ns: "Takeaway" })
                            : t("product.bindStatusNo", { ns: "Takeaway" });
                    newItem.itemSizeName = newItem.unitName || ""
                }
                // else {
                //     newItem.syncStatusValue = item.syncStatus;
                //     if (syncStatusOptions) {
                //         newItem.syncStatus =
                //             syncStatusOptions.find((child: any) => child.value === item.syncStatus)?.label || "";
                //     }
                // }

                const trdItemsData = newItem.trdItems && newItem.trdItems.map((el: any) => {
                    el.nid = el.trdItemId + el.trdUnitId
                    el.bing = true;
                    return el
                });
                const keydata: any = {}
                if (trdItemsData && trdItemsData.length > 0) {
                    for (const i in trdItemsData[0]) {
                        keydata[i] = [];
                    }
                    trdItemsData.forEach((el: any) => {
                        Object.keys(keydata).forEach((item: any) => {
                            let value = el[item]
                            if (item == "trdItemType" && value == "Single") {
                                value = "Item"
                            }
                            keydata[item].push(value)
                        })
                    })
                }
                if (newItem.skuId) {
                    newItem.leftnid = newItem.itemId + newItem.skuId
                } else {
                    newItem.leftnid = newItem.itemId + newItem.unitId
                }


                return {
                    ...newItem,
                    ...keydata
                };
            });
            callback({
                code,
                list: newList,
                page: {
                    current: data.page?.pageNo || 1,
                    total: data.page?.total,
                    pageSize: data.page?.pageSize,
                },
                notBindCount: notBindCount
            })
        } catch (e) {
            console.error(e);
        }
    };

    const queryParams = {
        shopId: queryData.shopId,
        platform: queryData.platform,
        trdMenuId: queryData.trdMenuId || "",

        menuId: queryData.menuId || "",
        itemFilter: queryData.itemFilter || {},
        trd: queryData.trd,
        ...queryData.itemFilter
    };
    if (queryData?.page && queryData?.page.pageNo) {
        queryParams.page = {
            pageNo: queryData?.page?.pageNo,
            pageSize: queryData?.page?.pageSize,
        }
    }

    if (situationsCheck(queryData?.channel, "outSide", ["hungryPanda"])) {
        // 属于up外卖的 走另一个接口
        upItemBindingList(queryParams)
            .then((res: any) => {
                resSetData(res);
            })
            .catch((err) => {
                catchCallback?.(err.code)
            });
    } else if (queryData?.channel === "hungryPanda") {
        queryItems(queryParams)
            .then((res: any) => {
                resSetData(res);
            })
            .catch((err) => {
                catchCallback?.(err.code)
            });
    } else {
        itemQuery({
            ...queryParams,
            channel: queryData?.channel,
        }).then((res: any) => {
            res.data.itemRelations = res.data.list
            resSetData(res);
        })
            .catch((err: any) => {
               catchCallback?.(err.code)
            });
    }
};

// 获取未绑定三方平台商品-后期可能弃用  ---- 已弃用
export const getUnbingThirdItem = (queryData?: any, callback?: any, catchCallback?: any) => {
    // if (["urbanPiper", "chowly", "grab", "hungryPanda"].indexOf(queryData?.channel) < 0) {
    //     elemeQueryPageUnbindItems({
    //         shopId: queryData.shopId,
    //         platform: queryData.platform,
    //         channel: queryData?.channel,
    //         itemFilter: {},
    //         page: {
    //             pageNo: 1,
    //             pageSize: 10,
    //         },
    //     })
    //         .then((res: any) => {
    //             callback(res);
    //         })
    //         .catch((e) => {
    //             catchCallback && catchCallback(e)
    //         });
    // } else {
    //     catchCallback && catchCallback()
    // }
}

// 控制不符合条件的三方菜品不进行绑定  ---- 已弃用
export const existenceOrnot = (dragId: string, dropId: string, leftDishs?: any, rightDishs?: any, isNoneMsg?: boolean) => {
    let state = false;

    // 左侧拖入区域的 trdPosItemId
    const dragtrdPosItem = rightDishs.find((o: any) => o.nid == dragId) || {
        trdItemId: "",
    };

    console.log("nid", rightDishs, dragtrdPosItem)
    const dragtrdPosItemId = dragtrdPosItem.trdItemId;
    if (dragtrdPosItemId) {
        // 拖拽时，当左侧为多规格菜品，其中一项绑定了右侧的一个多规则菜品，限制再次拖拽右侧多规格菜品的另外一项绑定其它菜品
        // 判断左侧是否存在 trdPosItemId 的菜品，多规格三方菜品的 trdPosItemId 相同，
        // 获取 存在 trdPosItemId 的菜品 的 itemId
        // const existenceOrnotitemIdRight = leftDishs.find(
        //     (o: any) => o.trdPosItemId == dragtrdPosItemId
        // ) || { itemId: "" };
        const existenceOrnotitemIdRight = leftDishs.find(
            (o: any) => {
                if (o.trdItems
                    .find((p: any) => p.trdItemId == dragtrdPosItemId)) {
                    return o
                }
            }
        ) || { itemId: "" };
        if (existenceOrnotitemIdRight.itemId) {
            // 如果左侧存在与拖入三方菜品相同的 trdItemId
            // 获取被拖入的左侧菜品的 itemid
            const existenceOrnotitemIdLight = leftDishs.find((o: any) => o.leftnid == dropId) || {
                itemId: "",
            };
            if (existenceOrnotitemIdLight.itemId) {
                // 判断 被拖入的菜品 itemId 与 匹配到的 existenceOrnotitemId 是否相同
                if (existenceOrnotitemIdRight.itemId != existenceOrnotitemIdLight.itemId) {
                    // message.warning({
                    //     content: `三方商品[${existenceOrnotitemIdRight.trdItems[0].trdItemName
                    //         }]，已绑定至当前外卖菜单的[${existenceOrnotitemIdRight.itemName}]，解绑后[${dragtrdPosItem.trdItemName
                    //         }/${dragtrdPosItem.trdUnitName || "-"}]才可绑定至[${existenceOrnotitemIdLight.itemName
                    //         }]`,
                    //     duration: 5,
                    // });
                    if (!isNoneMsg) {
                        message.warning({
                            content: t("instant.unbindItem", {
                                ns: "Takeaway", trdItemName: `[${existenceOrnotitemIdRight.trdItems[0].trdItemName
                                    }]`, itemName: `[${existenceOrnotitemIdRight.itemName}]`, name: `[${dragtrdPosItem.trdItemName
                                        }/${dragtrdPosItem.trdUnitName || "-"}]`, sizeName: `[${existenceOrnotitemIdLight.itemName
                                            }]`
                            }),
                            duration: 5,
                        });
                    }

                    state = true;
                } else {
                    console.log("可以拖拽进入");
                }
            }
        }




        // 当左侧多规格菜品已经绑定了一个三方菜，限制再拖拽绑定其它三方菜品，只有同trdPosItemId可以进行绑定
        // 将被绑定左侧菜
        const dropItem = leftDishs.find((o: any) => o.leftnid == dropId) || { itemId: "" };

        // 每个左侧菜，只能绑定一个菜，或一个菜的多规格
        // if (dropItem.trdItems && dropItem.trdItems.length > 0) {
        //     if (dropItem.trdItems[0].trdItemId != dragtrdPosItem.trdItemId) {
        //         message.warning({
        //             content: `[${dropItem.itemName}]已绑定[${dropItem.trdItems[0].trdItemName}]，解绑后[${dropItem.itemName}/${dropItem.itemSizeName || "-"
        //                 }]才可绑定[${dragtrdPosItem.trdItemName}]`,
        //             duration: 5,
        //         });
        //         state = true;
        //     }
        // }

        // 已经绑定三方菜的 同 规格左侧菜
        const itemIdList = leftDishs.filter(
            (o: any) => o.itemId == dropItem.itemId && o.trdItems && o.trdItems.length > 0
        );
        const item: any = leftDishs.find((o: any) => o.itemId == dropItem.itemId && o.trdItems.length > 0);
        if (
            itemIdList.length > 0 &&
            itemIdList.flatMap((o: any) => o.trdItems.map((m: any) => m.trdItemId)).indexOf(dragtrdPosItemId) < 0
        ) {
            // message.warning({
            //     content: `[${item.itemName}]已绑定[${item.trdItems[0].trdItemName}]，解绑后[${dropItem.itemName}/${dropItem.itemSizeName || "-"
            //         }]才可绑定[${dragtrdPosItem.trdItemName}]`,
            //     duration: 5,
            // });
            if (!isNoneMsg) {
                message.warning({
                    content: t("instant.unbindItemAndBindAnother", {
                        ns: "Takeaway", itemName: `[${item.itemName}]`, trdItemName: `[${item.trdItems[0].trdItemName}]`, name: `[${dragtrdPosItem.trdItemName}/${dragtrdPosItem.trdUnitName || "-"}]`, ItemName: `[${dropItem.itemName}]`
                    }),
                    duration: 5,
                });
            }

            state = true;
        }
    }

    return false;
}

export const findItemById = (array: any, id: any) => {
    // 定义一个辅助函数来递归搜索
    const searchdata: any = (items: any) => {
        for (const item of items) {
            if (item.value === id) {
                return item.name; // 找到匹配的id，返回name
            }
            // 如果当前项有children属性，递归搜索children
            if (item.children && item.children.length > 0) {
                const result = searchdata(item.children);
                if (result) return result; // 如果在子数组中找到结果，返回结果
            }
        }
        return null; // 如果没有找到，返回null
    };

    return searchdata(array); // 调用辅助函数并返回结果
};

// 国内平台绑定与解绑
export const bindAndUnbind = (channelShopId: string, menuId: string, mappings: any, flushAll?: boolean, callback?: any) => {
    const params = {
        channelShopId,
        menuId,
        mappings,
        flushAll
    };
    itemMap(params)
        .then((res: any) => {
            callback(res)
        })
        .catch(() => {
            callback({
                code: -1
            })
        });
}

const removeIntersection = (arr1: any = [], arr2: any = []) => {
    // 将第二个数组转换为Set，以便快速查找
    const set2 = new Set(arr2);
    // 使用filter方法和Set的has方法来过滤掉两个数组的交集元素
    const filteredArr1 = arr1.filter((item: any) => !set2.has(item));
    return filteredArr1;
}

// 国内外情景判断
// channel:渠道
// type:类型
// exclusion:排除项
// insert:插入项
export const situationsCheck = (channel: string, type: string, exclusion?: string[], insert?: string[]) => {
    insert = insert ? insert : []
    const inSide = [
        "uberEats",
        "douyin",
        "eleme",
        "meituan",
        "candao",
        "elemeMerchant",
        "meituanMerchant",
        "douyinMerchant",
    ]
    const outSide = ["urbanPiper", "hungryPanda", "doorDash", "justEat", "grab", "chowly", "foodPanda", "fantuan", "deliveroo"]
    const channelObj: any = {
        "inSide": [...removeIntersection(inSide, exclusion), ...insert],
        "outSide": [...removeIntersection(outSide, exclusion), ...insert],
    }
    if (channelObj[type].indexOf(channel) > -1) {
        return true
    }
    return false
}