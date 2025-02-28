import { useMemo, useCallback } from "react";
import { useLoaderData } from "react-router-dom";
import { useTranslation } from "react-i18next";
import _ from "lodash";

/**
 * 获取当前页面LoaderData中获取对应的block数据
 * @param key blockId
 * @returns 
 */
export function useBlockData(key: string) {
    const { pageUtils } = useLoaderData() as any;
    return useMemo(() => pageUtils.getBlockData(key), [pageUtils, key]);
}

/**
 * 从当前页面LoaderData中获取枚举字段对应的多语言文本
 * @param blockId 所属blockId，不填写时进行全局匹配，建议添加以获得更好的性能和准确性
 * @returns 返回函数，通过枚举字段和枚举值获取当前语言对应的值
 */
export function useEnumFieldText(blockId?: string) {
    const { pageUtils } = useLoaderData() as any;
    const { i18n } = useTranslation();
    const fields = useMemo(() => {
        const children = _.get(pageUtils, "pageMeta.children", []);
        if (blockId) {
            return children.find((x: any) => x.blockId === blockId)?.fields;
        } else {
            return _.concat(...children.map((x: any) => x.fields));
        }
    }, [blockId, pageUtils]);
    return useCallback(
        /**
         * 通过枚举字段和枚举值获取当前语言对应的值
         * @param fieldId 枚举字段
         * @param value 枚举值
         * @returns 枚举对应的多语言文本
         */
        (fieldId: string, value: any) => {
            if (!fieldId || !fields) return value;
            const field = fields.find((x: any) => x.fieldId === fieldId && x.data?.dataSource);
            if (!field) return value;
            const item = field.data.dataSource.find((x: any) => x.value === value);
            if (!item) return value;
            return item.languageData[i18n.language] || value;
        },
        [fields, i18n.language]
    );
}