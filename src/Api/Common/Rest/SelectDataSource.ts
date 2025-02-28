import { IKVProps } from "@restosuite/field-core";
import { getCategoryList } from "@src/Api/Item/Category";

export const getCategory = (
  extraParams?: IKVProps,
  axiosConfig?: any
): Promise<IKVProps> => {
  return new Promise((resolve, reject) => {
    getCategoryList(
      {
        cateGoryLevelType: "0",
        isArchived: false,
        isSubArchived: false,
        ...extraParams,
      },
      axiosConfig
    )
      .then((res: IKVProps) => {
        const list = res.data.map((v: any) => {
          v.label = v.name;
          v.value = v.dataId;
          if (v.subCategorys && v.subCategorys.length) {
            v.children = v.subCategorys.map((w: any) => ({
              ...w,
              label: w.name,
              value: w.dataId,
            }));
          }
          return v;
        });
        resolve(list);
      })
      .catch((error) => {
        const rejectedError =
          error instanceof Error ? error : new Error(String(error));
        reject(rejectedError);
      });
  });
};
