import { useCallback } from "react";
import { i18n } from "@restosuite/bo-common";
import _ from "lodash";

const useLanguageText = (tableData: any) => {
  const getLanguageText = useCallback(
    (fieldId: string, value: string) => {
      const dataSource = _.find(tableData.fields, { fieldId })?.data?.dataSource;
      return _.find(dataSource, { value })?.languageData[i18n.language];
    },
    [tableData]
  );

  return getLanguageText;
};

export default useLanguageText;