import { Tabs, Empty, Spin } from "antd";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

import { useTranslation } from "react-i18next";
import {
  platformList,
  threeLevelLinkageQuery,
} from "@src/Api/Takeaway/StoreAndItems";
import { rootStore } from "@src/Store";
import styles from "./index.module.less";
import { useTabActive } from "@restosuite/fe-skeleton";

const View = (props: any) => {
  const { actionCallback, threeLevelLinkageLanguage, onNodata, businessType } =
    props;
  const { t, i18n } = useTranslation(["Common"]);
  const [pageId, setPageId] = useState<string>("loading");
  const [list, setList] = useState<any[]>([]);
  const [type, setType] = useState<any>();
  const [defaultKeys, setDefaultKeys] = useState<any>(
    sessionStorage.getItem("takoutMapTabskey") || ""
  );
  const [renderKey,setRenderKey] = useState("")
  // useTabActive(() => {
  //   const key = sessionStorage.getItem("takoutMapTabskey")
  //   setDefaultKeys(key);
  //   setType(key);
  //   setRenderKey(`${Math.random()}`)
  //   console.log("666666",defaultKeys,key)
  // });

  const onTabClick = (evt: string) => {
    sessionStorage.setItem("takoutMapTabskey", evt);
    setType(evt);
    const item = list.find((o) => o.key === evt);
    if (item && actionCallback) {
      actionCallback(item);
      console.log("5555555",item)
    }
  };

  useEffect(() => {
    if (list && list.length > 0) {
      if (defaultKeys) {
        console.log("11111111",defaultKeys)
        setType(defaultKeys);
        const item = list.find((o) => o.key === defaultKeys);
        if (item && actionCallback) {
          actionCallback(item);
          console.log("222222",defaultKeys)
        } else {
          actionCallback(list[0]);
          console.log("333333",defaultKeys)
          sessionStorage.setItem("takoutMapTabskey", list[0].key);
        }
      } else {
        if (actionCallback) {
          console.log("444444444",list[0])
          actionCallback(list[0]);
        }
      }
    }
  }, [list, defaultKeys,renderKey]);

  useEffect(() => {
    const languageObj: any = {};
    const userInfo = rootStore.loginStore.getUserInfo();
    const thirdConfiguration: any = threeLevelLinkageLanguage;
    if (thirdConfiguration?.contentLanguageList) {
      thirdConfiguration.contentLanguageList.forEach((item: any) => {
        if (!languageObj[item.key]) {
          languageObj[item.key] = {};
        }
        languageObj[item.key][item.languageCode] = item.text;
      });
    }
    platformList({
      corporationId: userInfo?.corporationId,
    })
      .then((platformRes) => {
        const plotformData = platformRes?.data || [];
        let fetchList = plotformData.map((item: any, index: number) => {
          return {
            channel: item.channel,
            key: item.type,
            label:
              languageObj[item.type == "doorDash" ? "DoorDash" : item.type]?.[
                i18n.language
              ] || item.type,
            businesses: item.businesses.map((item: any) => ({
              value: item,
              label: languageObj[item]?.[i18n.language] || item,
            })),
            orderSourceType: item.orderSourceType
              ? item.orderSourceType
              : 10000,
            children: <div></div>,
          };
        });
        if (businessType && businessType == "map") {
          fetchList = fetchList.filter((el: any) => {
            return (
              el.businesses &&
              el.businesses.map((m: any) => m.value).includes("takeOut")
            );
          });
        }
        fetchList = fetchList.sort((a: any, b: any) => {
          return a.orderSourceType - b.orderSourceType; // 对id进行减法运算，实现升序排序
        });
        setList(fetchList);
        if (fetchList && fetchList.length > 0) {
          setPageId("show");
        } else {
          setPageId("noData");
          onNodata?.();
        }
      })
      .catch(() => {
        //
      });
  }, []);

  return (
    <>
      {/* {pageId === "loading" && (
        <div className="h-[200px] flex items-center justify-center">
          <Spin />
        </div>
      )} */}
      {pageId === "show" && (
        <Tabs
          items={list}
          defaultActiveKey={defaultKeys}
          activeKey={type}
          onTabClick={onTabClick}
          className={styles.tabclass}
          tabPosition={"top"}
        />
      )}
      {/* {pageId === "noData" && noData} */}
    </>
  );
};

export default View;
