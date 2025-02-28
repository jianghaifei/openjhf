import { CommonUtils } from '@restosuite/bo-common';
import { IKVProps } from '@restosuite/field-core';


// 缓存bizConfig
let memoryBizConfig: IKVProps = {};
export const getBizConfig = (key: string) => {
  if (Object.keys(memoryBizConfig).length > 0) {
    return memoryBizConfig?.[key];
  }
  try {
    const res = JSON.parse(localStorage.getItem("bizConfig") || "{}");
    memoryBizConfig = res;
    return res?.[key];
  } catch (error) {
    console.error("getBizConfig error", error);
    return memoryBizConfig?.[key];
  }
};

export const {
  parseFlatDataToTreeData, getTreeParentNodeId, updateNames, appendQueryParams, setObjectToArray,
  moneyFormat, replaceArrayFieldName, parseLanguageData, getRequestHeaderInfo, getCurrencySymbol,
  getDateFormat, getTimeFormat, getDateTimeFormat, commonFormUploadMultipleLanguage,
  desensitizePhoneNumber, getCurrentTimeZone, generateMinMaxWithDecimalPlaces,
  isStoreView, getCurrencyOptions, isMultiCurrency, getCurrency, getItemCurrencySymbol,
  getCurrencyUnit, fenToYuan, yuanToFen, removeEmptyValueFromObject, isChinaGroup,
  formatLargeNumber, isNotSupportedTime, getFieldEnumByBlockData, getTextWidth, getMenuMaxTextWidth,
  getTextWidthAccurate, arrayToTree,
} = CommonUtils;

