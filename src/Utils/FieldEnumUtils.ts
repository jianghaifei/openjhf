import { rootStore } from "@src/Store";

// 解析接口返回的枚举值
const fieldEnumUtils = async (fieldEnumPromise: any) => {
    try {
        const res = await fieldEnumPromise;
        if (res.code === "000") {
            const { data } = res;
            const language = rootStore.loginStore.getLanguage();
            data.forEach((item: any) => {
                item.value = item.enumValueName;
                item.label = item?.commonMoreLanguage[language] || item.enumKeyName;
            });
        }
        return res?.data || [];
    } catch (error) {
        console.log("枚举值返回错误", error);
    }
};

export default fieldEnumUtils;