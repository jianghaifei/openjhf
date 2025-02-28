/* eslint-disable no-debugger */
/*
这里的公共函数只做业务相关的处理逻辑，比如业务数据的格式化，不具备通用性
*/
import { cloneDeep } from "lodash";
import { getCurrencySymbol } from "./CommonUtils";
import { IKVProps } from "@restosuite/field-core";
import { i18n } from '@restosuite/bo-common';
import ItemEnum from "@src/Locales/Constants/ItemEnum";
import _ from "lodash";

//item的列表需要根据数据的类型来格式化数据
export const formatItemListData = (data: any) => {
    if (!data || !Array.isArray(data)) {
        return [];
    }

    let currencySymbol = getCurrencySymbol();
    const newDataList: any[] = [];
    data.map((dataItem) => {
        let tempItem = cloneDeep(dataItem);
        const sizelist = tempItem.sizeList;
        const category = tempItem.category;
        // TODO 2024-09-24 如果数据里带货币符，用本身的，门店商品管理里，需要展示门店自身货币符
        if (dataItem?.currencySymbol) {
            currencySymbol = dataItem?.currencySymbol;
        }
        let categoryInfo = "";
        if (category) {
            if (category.topCategoryName && !_.isEmpty(category.topCategoryName)) {
                categoryInfo += category.topCategoryName;
            }
            if (
                category.subCategoryName &&
                !_.isEmpty(category.subCategoryName) &&
                !_.isEmpty(categoryInfo)
            ) {
                categoryInfo += "/";
                categoryInfo += category.subCategoryName;
            }
        }

        if (!sizelist || sizelist.length <= 0) {
            tempItem = {
                ...tempItem,
                basePrice:
                    tempItem.itemType === "Item"
                        ? i18n.t(ItemEnum.ItemOpen, { ns: "Item" })
                        : tempItem.basePrice,
                // 价格带渠道价
                price0:
                    tempItem.itemType === "Item"
                        ? i18n.t(ItemEnum.ItemOpen, { ns: "Item" })
                        : tempItem.basePrice,
                price1:
                    tempItem.itemType === "Item"
                        ? i18n.t(ItemEnum.ItemOpen, { ns: "Item" })
                        : tempItem.basePrice,
                price2:
                    tempItem.itemType === "Item"
                        ? i18n.t(ItemEnum.ItemOpen, { ns: "Item" })
                        : tempItem.basePrice,
            };
        } else if (sizelist.length === 1) {
            tempItem = {
                ...tempItem,
                basePrice: currencySymbol + sizelist[0].basePrice,
            };
            (sizelist[0].channelPriceList || []).forEach((v: any, i: number) => {
                tempItem[`price${i}`] = currencySymbol + v.price;
            });
        } else {
            const children: IKVProps[] = [];
            let min = -1.0;
            let max = -1.0;
            const arr: any = [[], [], [], [], [], [], [], [], []];
            sizelist.map((size: any, index: number) => {
                const price = parseFloat(size.basePrice);
                const child: IKVProps = { ...size };
                child["name"] = size.name;
                child["basePrice"] = currencySymbol + size.basePrice;
                child["parentDataId"] = tempItem.dataId;
                if (price < min || min === -1) {
                    min = price;
                }
                if (price > max || max === -1) {
                    max = price;
                }

                (size?.channelPriceList || []).forEach((v: any, i: number) => {
                    child[`price${i}`] = currencySymbol + v.price;
                    arr[i].push(v.price);
                });

                children.push(child);
            });
            const basePrice = currencySymbol + min + " - " + currencySymbol + max;
            tempItem = {
                ...tempItem,
                basePrice: basePrice,
                children: children,
            };
            arr.forEach((v: any, i: number) => {
                tempItem[`price${i}`] = v?.length ?
                    currencySymbol + _.min(v) + " - " + currencySymbol + _.max(v) : "-"
            });
        }
        //表格目前使用的aliasFieldId
        tempItem = {
            ...tempItem,
            "Categories.name": categoryInfo,
            "brand.brandName": tempItem?.brand?.brandName,
        };
        // console.log(tempItem);
        newDataList.push(tempItem);
    });

    return newDataList;
};

//item的列表需要根据数据的类型来格式化数据
export const formatFlatItemListData = (data: any) => {
    if (!data || !Array.isArray(data)) {
        return [];
    }

    const currencySymbol = getCurrencySymbol();
    const newDataList: any[] = [];
    data.map((dataItem) => {
        let tempItem = cloneDeep(dataItem);
        const sizelist = tempItem.sizeList;
        if (!sizelist || sizelist.length <= 0) {
            tempItem = {
                ...tempItem,
                basePrice:
                    tempItem.itemType === "Item"
                        ? i18n.t(ItemEnum.ItemOpen, { ns: "Item" })
                        : tempItem.basePrice,
            };
        } else if (sizelist.length === 1) {
            tempItem = {
                ...tempItem,
                basePrice: currencySymbol + sizelist[0].basePrice,
            };
        }

        if (sizelist.length >= 2) {
            console.log('22222222222222', sizelist);
            sizelist.map((size: any) => {
                const child: IKVProps = tempItem;
                child["name"] = size.name;
                child["basePrice"] = currencySymbol + size.basePrice;
                child["parentDataId"] = tempItem.dataId;
                newDataList.push(child);
            });
        } else {
            newDataList.push(tempItem);
        }
    });

    return newDataList;
};

//门店下发 Pos report 中的 basePrice 转换,根据 priceType 判断 basePrice 展示形式
export const parseMenuPublishReportBasePrice = (record: IKVProps) => {
    if (!record || !record.extendValue) {
        return "-";
    }
    const { extendValue, basePrice } = record;
    const currencySymbol = getCurrencySymbol();
    try {
        let _price = currencySymbol + basePrice;
        const _extendValue = JSON.parse(extendValue);
        const { priceRule, sizeList } = _extendValue;
        const _sizeList = sizeList ? JSON.parse(sizeList) : [];
        if (priceRule === "OPEN_PRICE") {
            _price = i18n.t(ItemEnum.ItemOpen, { ns: "Item" });
        }
        // 只有一个 size 时,直接展示
        if (_sizeList.length && _sizeList.length === 1) {
            _price = currencySymbol + _sizeList[0].basePrice;
        } else if (_sizeList.length && _sizeList.length > 1) {
            let min = -1.0;
            let max = -1.0;
            _sizeList.map((size: any) => {
                const price = parseFloat(size.basePrice);
                if (price < min || min === -1) {
                    min = price;
                }
                if (price > max || max === -1) {
                    max = price;
                }
            });
            _price = currencySymbol + min + " - " + currencySymbol + max;
        }
        return _price;
    } catch (error) {
        return "-";
    }
};

export const formatMenuItemListData = (data: any, currency?: string) => {
    // console.log('currency', currency);
    let currencySymbol = getCurrencySymbol();
    if (currency) {
        const currencyArr = currency.split(" - ")
        if (currencyArr?.length > 1) {
            currencySymbol = currencyArr[0]
        }
    }
    const _data = formatItemListData(data)
    const newDataList: any[] = [];
    _data.forEach(item => {
        const tempItem = cloneDeep(item);
        const sizeList = cloneDeep(tempItem.sizeList)
        if (tempItem?.currencySymbol) {
            currencySymbol = tempItem?.currencySymbol;
        }
        if (sizeList && sizeList?.length) {
            // 这里做渠道价的转换
            if (sizeList.length === 1) {
                (sizeList[0].channelPriceList || []).forEach((v: any, i: number) => {
                    const _price = (_.isNumber(v.price) ? v.price : v.initialPrice) || "-"
                    tempItem[v.channel] = currencySymbol + _price;
                    sizeList[0][v.channel] = currencySymbol + _price;
                })
            } else {
                // 价格区间
                const priceRange: IKVProps = {}
                tempItem.children = sizeList.map((size: IKVProps) => {
                    if (size && size.channelPriceList?.length) {
                        size?.channelPriceList?.forEach((v: any, i: number) => {
                            const _price = (_.isNumber(v.price) ? v.price : v.initialPrice) || "-"
                            size[v.channel] = currencySymbol + _price
                            if (!(v.channel in priceRange)) {
                                priceRange[v.channel] = []
                            }
                            priceRange[v.channel].push(_price);
                        });
                    }
                    return size
                })
                Object.keys(priceRange)
                    .forEach((key) => {
                        const rangeArr = priceRange[key]
                        tempItem[key] = rangeArr?.length ?
                            currencySymbol + _.min(rangeArr) + " - " + currencySymbol + _.max(rangeArr) : "-"
                    });
            }
        }
        newDataList.push(tempItem);
    })
    return newDataList
}