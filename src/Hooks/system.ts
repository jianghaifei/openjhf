import GlobalConfig, { IRequestEnvEnm } from "@src/GlobalConfig";
import { useMemo } from "react";

type UseAdminCodeResult = [string, string, string] & {
    /**
     * 集团管理员编码
     */
    cropAdminCode: string,
    /**
     * 品牌管理员编码
     */
    brandAdminCode: string,
    /**
     * 配送中心管理员编码
     */
    districtAdminCode: string
}

/**
 * 获取管理员编码
 * @returns 
 */
export function useAdminCode(): UseAdminCodeResult {
    return useMemo(() => {
        const isDev = GlobalConfig.currentEnv === IRequestEnvEnm.Dev;
        const cropAdminCode = isDev ? "sys_0" : "sys_20";
        const brandAdminCode = isDev ? "sys_2" : "sys_21";
        const districtAdminCode = isDev ? "sys_200027" : "sys_1800001";
        const result = [cropAdminCode, brandAdminCode, districtAdminCode];
        Object.assign(result, {
            cropAdminCode,
            brandAdminCode,
            districtAdminCode
        });
        return result as any;
    }, []);
}