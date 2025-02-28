/* elnt-disable no-debugger */
import { Input, Checkbox, Radio, Button, Space, InputNumber } from "antd";
import _ from "lodash";
import { t } from "i18next";
import { useField, useFormEffects } from "@formily/react";
import { DataField, onFieldValidateStart } from "@formily/core";
import { IKVProps } from "@restosuite/field-core";
import { useTranslation } from "react-i18next";
import { useEffect, useRef, useState } from "react";
import styles from "./index.module.less";
import { QuestionCircleOutlined } from "@ant-design/icons";
import { stringify } from "querystring";

import { shopQueryChannelShopInfo } from "@src/Api/Takeaway/AggregateManagement";

const TakoutInputButton = (props: any) => {
  const { i18n } = useTranslation();
  const { onChange, searchParams = {} } = props;
  const field = useField<DataField>();

  const [searchVal, setSearchVal] = useState("");
  const [loading, setloading] = useState(false);

  const searchBtn = () => {
    console.log("searchParams", searchParams);
    if (!searchVal) {
      return;
    }
    setloading(true);
    shopQueryChannelShopInfo({
      ...searchParams,
      channelShopId: searchVal,
    })
      .then((res: any) => {
        setloading(false);
        console.log("ddddd", res);
        onChange &&
          onChange({
            ...res.data,
            channelShopId: searchVal,
          });
      })
      .catch(() => {
        setloading(false);
      });
  };

  return (
    <div className={styles.TakoutInputButton}>
      <Input
        defaultValue={field.value && field.value.channelShopId}
        onChange={(e: any) => {
          setSearchVal(e.target.value);
          onChange && onChange(e.target.value);
        }}
      />
      <Button type="primary" onClick={searchBtn} loading={loading}>
        查询店铺信息
      </Button>
    </div>
  );
};

export default TakoutInputButton;
