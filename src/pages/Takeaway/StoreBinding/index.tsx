import { Switch, message, Button, Space, Modal, Tag, Spin } from "antd";
import { IKVProps } from "@restosuite/field-core";
import { useLoaderData } from "react-router-dom";
import { useEffect, useMemo, useRef, useState } from "react";
import styles from "./Components/index.module.less";
import { useTranslation } from "react-i18next";
import PageContainer from "@src/Components/Layouts/PageContainer";
import useCustomNavigate from "@src/Hooks/useCustomNavigate";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
} from "@restosuite/field-components";
import { ITable } from "@src/Components/Table/ITable";
import { useStore } from "@src/Store";
import ServiceTabs from "../Components/ServiceTabs";
import MeituanBind from "./Components/MeituanBind";
import ElementBind from "./Components/ElementBind";
import AbroadBind from "./Components/AbroadBind";
import CandaoBind from "./Components/CandaoBind";
import GeneralBind from "./Components/GeneralBind";
import DischargeModel from "./Components/DischargeModel";
import BusinessSet from "./Components/BusinessSet";

import {
  changeOperateShop,
  merchantGetAuth,
  channelAuthaddShop,
  shopPageShop,
  merchantlistMerchant,
  threeLevelLinkageQuery,
  newAddMerchant,
  addShopFromMerchant,
  newRemoveShop,
} from "@src/Api/Takeaway/StoreAndItems";
import { rootStore } from "@src/Store";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import _, { divide } from "lodash";
import { EditOutlined } from "@ant-design/icons";
import { useTabActive } from "@restosuite/fe-skeleton";

const View = () => {
  const { dispatchNavigate } = useCustomNavigate();
  const { pageUtils } = useLoaderData() as any;
  const tableRef = useRef<any>(null);
  const authDataRef = useRef<any>({});
  const [authData, setAuthData] = useState<any>(authDataRef.current);

  const meituanBindRef = useRef<any>(null);
  const elemeBindRef = useRef<any>(null);
  const abroadBindRef = useRef<any>(null);
  const candaoBindRef = useRef<any>(null);
  const GeneralBindRef = useRef<any>(null);
  const DischargeRef = useRef<any>(null);
  const BusinessSetref = useRef<any>(null);

  const [tableDate, setTableDate] = useState<any>([]);

  const { t, i18n } = useTranslation(["Common"]);
  const pageContainerRef = useRef<any>(null);
  const [renderKey, setRenderKey] = useState<string>("1");
  const [type, setType] = useState<string>("");
  const [typeObj, setTypeObj] = useState<IKVProps>({});
  const basicQueryRef = useRef<any>({});
  const queryRef = useRef<any>({});
  const [isMerchant, setIsMerchant] = useState(false);
  const [threeLevelLinkageLanguage, setThreeLevelLinkageLanguage] =
    useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [pureWidth, setPsureWidth] = useState<number>(0);
  const titletext = t("takeaway.titleStoreBind", { ns: "Takeaway" });
  const buttonTextRef = useRef<any>(null);
  const [resCode, setResCode] = useState<any>(null);

  const shopTitle: any = {
    meituan: t("instant.MEITUAN", { ns: "Takeaway" }), // 美团
    meituanMerchant: t("instant.MEITUANBrand", { ns: "Takeaway" }), // "美团品牌商",
    eleme: t("instant.ELA", { ns: "Takeaway" }), //"饿了么",
    elemeMerchant: t("instant.ELABrand", { ns: "Takeaway" }), //"饿了么品牌商",
    douyin: t("instant.DOBU", { ns: "Takeaway" }), //"抖音",
    douyinMerchant: t("instant.DOBUBrand", { ns: "Takeaway" }), //"抖音品牌商",
    hungryPanda: t("instant.Panda", { ns: "Takeaway" }), //"熊猫外卖",
    candao: t("instant.CANDAO", { ns: "Takeaway" }), //"餐道",
    miaoti: t("instant.MiaoTi", { ns: "Takeaway" }), // 秒提
    meituanmiaoti: t("instant.MEITUANMiaoTi", { ns: "Takeaway" }), // 美团秒提
    uberEats: "Uber Eats",
    justEat: "Just Eat",
    doorDash: "DoorDash",
    DoorDash: "DoorDash",
    grab: "grab",
  };

  useTabActive(() => {
   setRenderKey(`${Math.random()}`);
  });

  useEffect(()=>{
    console.log("这是新框架")
  },[])

  const formBlockData = useMemo(() => {
    const blockData: any = pageUtils.getBlockData("QueryForm");
    const customField = pageUtils.getBlockData("QueryFormCustomField");
    if (blockData?.fields) {
      blockData.fields.unshift({
        fieldType: "CustomFieldComponent",
        title: ["zh_HK", "zh_CN"].includes(i18n.language) ? "" : " ",
        fieldId: "combinedFields",
        languageData: {},
        fieldProps: {
          customFieldComponent: "CombinedTypeInput",
        },
        componentProps: {
          customFields: customField?.fields,
          allowClear: false,
        },
      });
      blockData.fields = blockData?.fields.map((el: any) => {
        if (el.fieldId && el.fieldId == "authStatus" && el.data.dataSource) {
          el.data.dataSource = el.data.dataSource.filter(
            (item: any) => item.value != "removed"
          );
        }
        return el;
      });
    }
    console.log("blockData", blockData);
    return blockData;
  }, [pageUtils]);

  const tableBlockData = useMemo(() => {
    const blockData: any = pageUtils.getBlockData("TableList");
    // 隐藏秒提营业时间，待秒提上线后放开
    blockData.fields = blockData?.fields.filter(
      (o: any) => o.fieldId != "businessTime"
    );
    return blockData;
  }, [pageUtils]);

  // 加载多语言
  const getthreeLevelLinkageQuery = () => {
    threeLevelLinkageQuery({
      queryLanguage: true,
    }).then((res: any) => {
      if (res.code != "000") return;
      setThreeLevelLinkageLanguage(res.data);
    });
  };
  useEffect(() => {
    getthreeLevelLinkageQuery();
  }, []);

  // 多通道
  const tableColumns: ITable["columns"] = [
    {
      dataIndex: "businesses",
      render(value: string[], row: IKVProps) {
        return (
          <div>
            {row.businessesList
              ? row.businessesList.map((o: any, key: number) => {
                  // 临时去掉
                  if (!typeObj.businesses) {
                    return null;
                  }
                  const label =
                    typeObj.businesses.find(
                      (child: any) => child.value === o.label
                    )?.label || o.label;
                  return (
                    <div key={key} className={styles.divrowClass}>
                      <Tag
                        ref={(el) => {
                          if (!listItemsRef.current[row.index]) {
                            listItemsRef.current[row.index] = [];
                          }
                          listItemsRef.current[row.index][key] = el;
                        }}
                        // className={styles.Tagclass}
                        closeIcon={o.isHover}
                        style={
                          o.isHover
                            ? { width: `${o.tagWidth + 14}px` }
                            : {
                                width: `${o.tagWidth}px`,
                              }
                        }
                        onMouseEnter={(e: any) => setTagHoverFn(row, o, true)}
                        onMouseLeave={(e: any) => setTagHoverFn(row, o, false)}
                        onClose={(e: React.MouseEvent<HTMLElement>) => {
                          e.preventDefault();
                          if (!row.channels[key].id) {
                            return;
                          }
                          if (row.channels[key].channel == "meituan") {
                            newRemoveShop({
                              id: row.channels[key].id,
                            }).then((res: any) => {
                              const { data, code } = res;
                              if (code != "000") return;
                              DischargeRef.current?.open({
                                url: data ? data?.authUrl : "",
                                record: row.channels[key],
                                merchants: row.channels[key],
                                channelObj: typeObj,
                              });
                            });
                          } else {
                            DischargeRef.current?.open({
                              record: row.channels[key],
                              merchants: row.channels[key],
                              channelObj: typeObj,
                            });
                          }
                        }}
                      >
                        {label}
                      </Tag>
                    </div>
                  );
                })
              : "-"}
          </div>
        );
      },
    },
    {
      dataIndex: "openStatus",
      render(value: any, row: IKVProps) {
        return value && value.length > 0
          ? value.map((el: any, index: number) => {
              if (
                row.business &&
                row.business[index] &&
                row.business[index] == "groupPurchase"
              ) {
                return <span>-</span>;
              }
              return (
                <div key={index} className={styles.divrowClass}>
                  <Switch
                    checked={el == 1}
                    onChange={(evt: any) => {
                      Modal.confirm({
                        title: t("common.tips", { ns: "Common" }),
                        content: t("product.confirmOperaNext", {
                          ns: "Takeaway",
                        }),
                        onOk() {
                          changeOperateShop({
                            platform: basicQueryRef.current?.platform,
                            shopId: row.shopId,
                            id: row.id[index],
                            openStatus: evt ? "1" : "0",
                          })
                            .then((res) => {
                              const { code, data } = res;
                              if (code === "000") {
                                message.success(
                                  t("receipt_template.opera_success", {
                                    ns: "Restaurant",
                                  })
                                );
                                fetchData();
                              }
                            })
                            .catch((err) => {
                              //
                            });
                        },
                      });
                    }}
                  ></Switch>
                </div>
              );
            })
          : "-";
      },
    },
    {
      dataIndex: "trdShopId",
      render(value: any, row: IKVProps) {
        return row.platformId && row.platformId.length > 0
          ? row.platformId.map((el: any, index: number) => (
              <div key={index} className={styles.divrowClass}>
                {el}
              </div>
            ))
          : "-";
      },
    },
    {
      dataIndex: "trdShopName",
      render(value: any, row: IKVProps) {
        return row.platformName && row.platformName.length > 0
          ? row.platformName.map((el: any, index: number) => (
              <div key={index} className={styles.divrowClass}>
                {el}
              </div>
            ))
          : "-";
      },
    },
    {
      dataIndex: "businessTime",
      render(value: any, row: IKVProps) {
        return (
          value &&
          value.map((el: any, index: number) => {
            const editFn = (
              id: string,
              selectBusiness: string,
              businessTime?: any
            ) => {
              BusinessSetref.current?.open({
                record: {
                  id: id,
                  businessTime: businessTime,
                  shopId: row.shopId,
                  shopName: row.shopName,
                },
                selectBusiness: selectBusiness,
              });
            };
            if (el && el.weeks && el.weeks.length > 0) {
              const items: any[] = el.weeks;

              // 获取第一项的开始时间和结束时间
              const firstItem = items[0];
              const firstStartTime = firstItem.periods[0].startTime;
              const firstEndTime = firstItem.periods[0].endTime;

              // 检查所有项的开始时间是否与第一项的开始时间一致
              const areStartTimesConsistent = items.every(
                (item) => item.periods[0].startTime === firstStartTime
              );

              // 检查所有项的结束时间是否与第一项的结束时间一致
              const areEndTimesConsistent = items.every(
                (item) => item.periods[0].endTime === firstEndTime
              );
              if (areStartTimesConsistent && areEndTimesConsistent) {
                el = (
                  <div style={{ whiteSpace: "nowrap" }}>
                    {firstStartTime}~{firstEndTime}{" "}
                    <EditOutlined
                      style={{
                        color: "rgba(148, 148, 148, 1)",
                        cursor: "pointer",
                      }}
                      onClick={() => {
                        editFn(row.id[index], row.business[index], items);
                      }}
                    />
                  </div>
                );
              } else {
                el = (
                  <div style={{ whiteSpace: "nowrap" }}>
                    {t("mainBranch.alreadySet", { ns: "Financial" })}{" "}
                    {/* 已设置{" "} */}
                    <EditOutlined
                      style={{
                        color: "rgba(148, 148, 148, 1)",
                        cursor: "pointer",
                      }}
                      onClick={() => {
                        editFn(row.id[index], row.business[index], items);
                      }}
                    />
                  </div>
                );
              }
            } else if (row.business[index] == "miaoti") {
              el = (
                <div style={{ whiteSpace: "nowrap" }}>
                  -{" "}
                  <EditOutlined
                    style={{
                      color: "rgba(148, 148, 148, 1)",
                      cursor: "pointer",
                    }}
                    onClick={() => {
                      editFn(row.id[index], row.business[index]);
                    }}
                  />
                </div>
              );
            } else {
              el = <div>-</div>;
            }

            return el;
          })
        );
      },
    },
  ];

  const tabChange = (evt: IKVProps) => {
    console.log("000000", evt);
    setIsMerchant(false);
    tableRef.current?.removeMemoryAction();
    const userInfo = rootStore.loginStore.getUserInfo();
    basicQueryRef.current = {
      platform: evt.key,
      channel: evt.channel,
      businesses: evt.businesses || [],
      corporationId: userInfo?.corporationId,
    };
    setTypeObj(evt);
    // 这里先改成接口返回的通道，通道会包含多个平台，目前授权的逻辑是按照通道做区分的
    setType(evt.channel);
    // if (queryRef.current.page) {
    //   tableRef.current?.setTableData([]);
    //   fetchData();
    // }
    // 获取商户授权状态
    getMerchantlistMerchant();
    // if (["meituan", "eleme", "douyin"].indexOf(evt.key) > -1) {

    // } else {
    //   setIsMerchant(false);
    // }
    setRenderKey(`${Math.random()}`);
  };

  // 控制支持商户授权的按钮是否显示
  const getMerchantlistMerchant = () => {
    merchantlistMerchant({
      platform: basicQueryRef.current.platform,
    })
      .then((res: any) => {
        if (res.code == "000") {
          let num = 0;
          for (const i in res.data.businesses) {
            const el = res.data.businesses[i];
            for (const j in el) {
              if (j != "business" && el[j].length > 0) {
                num++;
              }
            }
          }
          if (num == 0) {
            setIsMerchant(false);
          } else {
            setIsMerchant(true);
          }
        }
      })
      .catch((err) => {
        console.log(err);
      });
  };

  // 获取是否已经进行或商户授权
  const getTypeAuth = () => {
    const userInfo = rootStore.loginStore.getUserInfo();
    // 先获取授权状态
    merchantGetAuth({
      corporationId: userInfo?.corporationId,
      platform: basicQueryRef.current.platform,
    })
      .then((authRes: any) => {
        const { code, data } = authRes;
        if (code === "000") {
          authDataRef.current = data;
          setAuthData(authDataRef.current);
        }
      })
      .catch((err) => {
        setAuthData({});
      });
  };

  const getPurwidth = () => {
    setPsureWidth(
      pageContainerRef?.current
        ? (pageContainerRef?.current?.getContentWidth() as number)
        : 0
    );
  };

  window.onresize = _.debounce(getPurwidth, 1);

  const actionCallback = (
    actionProps: IComposeTreeTableActionCallbackProps
  ) => {
    getPurwidth();
    console.log("actionProps", actionProps);
    if (!type) {
      return;
    }
    const actionParams: any = {
      page: {
        pageNo: actionProps.pageNo,
        pageSize: actionProps.pageSize || 10,
      },
      ...actionProps.formData,
    };
    // 对组合式筛选项做处理
    if (actionParams.combinedFields) {
      actionParams[actionParams.combinedFields?.fieldId] =
        actionParams.combinedFields?.value;
      delete actionParams.combinedFields;
    }
    if (actionParams.autoAccept === true || actionParams.autoAccept === false) {
      actionParams.autoAccept = actionParams.autoAccept === true ? 1 : 0;
    }
    if (actionParams.openStatus === true || actionParams.openStatus === false) {
      actionParams.openStatus = actionParams.openStatus === true ? 1 : 0;
    }
    actionParams.authStatus = actionParams.authStatus
      ? [actionParams.authStatus]
      : [];
    if (actionParams.shopName) {
      actionParams.shopNameLike = actionParams.shopName || "";
      delete actionParams.shopName;
    }
    if (actionParams.shopId) {
      actionParams.shopIds = [actionParams.shopId];
      delete actionParams.shopId;
    }
    if (actionParams.trdShopId) {
      actionParams.platformId = actionParams.trdShopId;
      delete actionParams.trdShopId;
    }
    if (actionParams.trdShopName) {
      actionParams.platformNameLike = actionParams.trdShopName;
      delete actionParams.trdShopName;
    }

    queryRef.current = actionParams;
    fetchData();
  };

  const fetchData = () => {
    // queryShopAuthList shopPageShop
    setLoading(true);
    shopPageShop({
      ...queryRef.current,
      platform: basicQueryRef.current.platform,
    })
      .then((res: any) => {
        setLoading(false);
        const { code, data } = res;
        if (code === "000") {
          const ndata = data.list.map((el: any, key: number) => {
            const keydata: any = {};
            if (el.channels && el.channels.length > 0) {
              for (const i in el.channels[0]) {
                if (i != "shopId" && i != "corporationId") {
                  keydata[i] = [];
                }
              }
              keydata["businessesList"] = [];
              keydata["entityId"] = [];

              el.channels.map((item: any, index: number) => {
                for (const k in item) {
                  if (k == "business") {
                    keydata["businessesList"].push({
                      index,
                      label: item[k],
                      isHover: false,
                      tagWidth: "",
                    });
                  }

                  if (k == "id") {
                    keydata["entityId"].push(item[k]);
                  }

                  if (k != "shopId" && k != "corporationId") {
                    keydata[k].push(item[k]);
                  }
                }
              });
            }
            return {
              channels: el.channels,
              index: key,
              ...el.shop,
              ...keydata,
            };
          });
          console.log("-----------",ndata)
          tableRef.current?.setTableData(ndata);
          setTableDate(ndata);
          tableRef.current?.setPagination({
            current: data.page?.pageNo || 1,
            pageSize: data.page?.pageSize || 10,
            total: data.page?.total,
          });
          setRefresh(ndata);
        }
      })
      .catch((err) => {
        setLoading(false);
        tableRef.current?.setTableData([]);
        tableRef.current?.setPagination({
          current: 1,
          total: 0,
        });
      });
  };
  // 由产品要求“授权业务类型” tag 标签需要鼠标滑过才展示关闭图标，且需要添加过渡动画，需要初始的 width 宽度，鼠标滑过加宽 tag 并显示关闭图标
  // 因为每行可能有多个 tag，所以需要创建授权业务类型 ref 二维数组，通过ref获取元素初次渲染后的宽度，并赋值
  const listItemsRef = useRef<any>([]);
  // 授权业务类型刷新
  const [refresh, setRefresh] = useState<any>();
  // 授权业务类型hover事件
  const setTagHoverFn = (record: any, o: any, key: boolean) => {
    const copytableDate = _.cloneDeep(tableDate);
    const newtableDate = copytableDate.map((el: any) => {
      if (el.shopId == record.shopId) {
        el.businessesList = el.businessesList.map((item: any) => {
          item.isHover = false;
          if (item.label == o.label) {
            item.isHover = key;
          }
          return item;
        });
      }
      return el;
    });
    console.log("999999",newtableDate)
    tableRef.current?.setTableData(newtableDate);
    setTableDate(newtableDate);
  };
  // 授权业务类型获取元素宽度
  useEffect(() => {
    if (tableDate && tableDate.length > 0) {
      const copytableDate = _.cloneDeep(tableDate);
      const newtableDate = copytableDate.map((el: any, index: number) => {
        const refbox = listItemsRef.current[index] || [];
        el.businessesList =
          el.businessesList &&
          el.businessesList.map((item: any, key: number) => {
            item.tagWidth = (refbox[key] || {}).offsetWidth;
            return item;
          });
        return el;
      });
      console.log("8888888",newtableDate)
      tableRef.current?.setTableData(newtableDate);
      setTableDate(newtableDate);
    }
  }, [refresh]);

  // 打开列表里的授权管理
  const onOpenBind = (record: any) => {
    // entityId[0],
    const userInfo = rootStore.loginStore.getUserInfo();
    GeneralBindRef.current?.open({
      modelTitle: "",
      record: {
        corporationId: userInfo?.corporationId,
        platform: basicQueryRef.current.platform,
        shopId: record.shopId,
        business: record.business,
        entityId: record.entityId ? record.entityId[0] : "",
        shopName: record.shopName,
        authType: record.channel,
      },
      type,
      typeObj,
      current: 0,
      isShop: true,
    });
  };

  // 多通道授权选择后回调
  const GeneralBindOnchange = (result: any) => {
    const apiFetch: any = {
      creatable: newAddMerchant,
      merchants: addShopFromMerchant,
      system: channelAuthaddShop,
    };
    const userInfo = rootStore.loginStore.getUserInfo();
    const {
      record,
      selectNode,
      isShop,
      current,
      selectBusiness,
      channel,
      merchants,
      authType,
    } = result;
    console.log("kkkkkkk", result);
    if (authType == "merchants") {
      elemeBindRef.current?.open({
        url: result?.authUrl,
        form: result.form,
        record: {
          corporationId: userInfo?.corporationId,
          platform: basicQueryRef.current.platform,
          shopId: record.shopId,
          business: selectBusiness,
          waitingKey: result?.waitingKey,
          channel: selectNode.channel,
          id: merchants?.id,
        },
        merchants,
        typeObj,
        channel: selectNode.channel,
        current: current,
      });
      return;
    }

    setLoading(true);
    apiFetch[authType]({
      platform: basicQueryRef.current.platform,
      channel: channel,
      business: selectBusiness,
      shopId: record.shopId,
      merchantId: merchants.id,
    })
      .then((res: any) => {
        const { data, code } = res;
        setLoading(false);
        if (code != "000") return;
        // 如果直接返回 success ，进行授权成功流程，如 秒提、餐道
        if (data.success) {
          message.success(t("storeBind.bindSuccess", { ns: "Takeaway" }));
          fetchData();
          if (selectBusiness == "miaoti") {
            BusinessSetref.current?.open({
              record: {
                platform: basicQueryRef.current?.platform,
                shopId: record.shopId,
                shopName: record.shopName,
                id: data.id,
                channel: merchants.channel,
                waitingKey: data?.waitingKey,
              },
              merchants,
              selectBusiness,
            });
          }
        }
        // 通过授权链接绑定
        if (data.authUrl) {
          // authUrlType 为 1，授权链接需要跳转新页，如美团
          // authUrlType 为 0，授权链接 内部 ifream 打开，如饿了么，抖音
          if (data.authUrlType == 1) {
            meituanBindRef.current?.open({
              url: data?.authUrl,
              authType,
              record: {
                corporationId: userInfo?.corporationId,
                platform: basicQueryRef.current.platform,
                shopId: record.shopId,
                shopName: record.shopName,
                business: selectBusiness,
                channel: merchants.channel,
                waitingKey: data?.waitingKey,
              },
              merchants,
            });
          } else {
            elemeBindRef.current?.open({
              url: data?.authUrl,
              authType,
              form: data.form,
              record: {
                corporationId: userInfo?.corporationId,
                platform: basicQueryRef.current.platform,
                shopId: record.shopId,
                shopName: record.shopName,
                business: selectBusiness,
                waitingKey: data?.waitingKey,
                channel: merchants.channel,
                id: data?.id,
              },
              merchants,
              typeObj,
              channel: merchants.channel,
              current: current,
            });
          }
        }

        // 通过 填写表单授权，如 "hungryPanda", "urbanPiper", "chowly", "grab"
        // "meituanMerchant", "elemeMerchant" "douyinMerchant" 这三种品牌商是个例外
        if (data.form && data.form.fields && data.form.fields.length > 0) {
          const formBlock: any = {
            blockId: "meituanBind",
            blockType: "form",
            maxColumns: 1,
            children: undefined,
            minColumns: 1,
            layout: 1,
            bizObjectCode: "TakeawayStoreBinding",
            isRefWholeObject: false,
            fields: [],
          };
          formBlock.fields = _.cloneDeep(data.form).fields.map((el: any) => {
            const item: any = {
              data: {},
              fieldId: el.name,
              fieldProps: {
                required: el.require,
              },
              fieldType: "Text",
              languageData: {},
              title: el.label,
            };
            delete item.componentProps;
            return item;
          });
          if (
            [
              "meituanMerchant",
              "meituanDianPing",
              "elemeMerchant",
              "douyinMerchant",
              "urbanPiper",
              "uberEats",
            ].indexOf(channel) >= 0
          ) {
            elemeBindRef.current?.open({
              url: data?.authUrl,
              authType,
              form: data.form,
              formBlock: formBlock,
              record: {
                corporationId: userInfo?.corporationId,
                platform: basicQueryRef.current.platform,
                shopId: record.shopId,
                shopName: record.shopName,
                business: selectBusiness,
                waitingKey: data?.waitingKey,
                channel: merchants.channel,
                id: data?.id,
              },
              merchants,
              typeObj,
              channel: merchants.channel,
              current: current,
            });
          } else {
            abroadBindRef.current?.open({
              form: data.form,
              authType,
              business: selectBusiness,
              type: "bind",
              block: formBlock,
              record: {
                corporationId: userInfo?.corporationId,
                platform: basicQueryRef.current.platform,
                shopId: record.shopId,
                shopName: record.shopName,
                business: selectBusiness,
                channel: selectNode.channel,
                waitingKey: data?.waitingKey,
              },
              merchants,
            });
          }
        }
      })
      .catch(() => {
        setLoading(false);
      });
  };

  const bottomBtns = useMemo(() => {
    if (isMerchant) {
      return (
        <Space>
          <Button
            ref={buttonTextRef}
            type="primary"
            onClick={() => {
              const userInfo = rootStore.loginStore.getUserInfo();
              GeneralBindRef.current?.open({
                modelTitle:
                  `${shopTitle[typeObj.key] || ""}${t(
                    "storeBind.merchantBind",
                    {
                      ns: "Takeaway",
                    }
                  )}` || t("takeaway.btnServiceBind", { ns: "Takeaway" }),
                record: {
                  corporationId: userInfo?.corporationId,
                  platform: basicQueryRef.current.platform,
                  business: basicQueryRef.current.businesses,
                  entityId: authData?.entityId,
                },
                type,
                typeObj,
                current: 0,
                isShop: false,
              });
              return;
            }}
          >
            {/* {typeObj.key === "douyin"
              ? "抖音来客商户授权"
              : `${shopTitle[typeObj.key] || ""}商户授权` || "商户授权"} */}
            {typeObj.key === "douyin"
              ? t("general.douyinMerchantAuth", { ns: "Financial" })
              : `${shopTitle[typeObj.key] || ""}${t("takeaway.btnServiceBind", {
                  ns: "Takeaway",
                })}` || t("takeaway.btnServiceBind", { ns: "Takeaway" })}
          </Button>
        </Space>
      );
    }

    return null;
  }, [type, authData, isMerchant, typeObj]);

  const countCharacters = (str: string) => {
    let count = 0;
    for (let i = 0; i < str.length; i++) {
      // 检查字符是否为中文字符
      if (/[\u4e00-\u9fa5]/.test(str[i])) {
        count += 2;
      } else {
        count += 1;
      }
    }
    const buttonWidth =
      (buttonTextRef.current && buttonTextRef.current.offsetWidth) || 200;
    return count * 16 + buttonWidth;
  };

  // 根据code判断展示信息
  const noData = useMemo(() => {
    if (resCode == "20090") {
      return (
        <>
          <div className="text-center">
            <div className="p-[20px]">
              {t("storeBind.noTrdAction", { ns: "Takeaway" })}
            </div>
          </div>
        </>
      );
    }
  }, [resCode]);

  return (
    <PageContainer
      ref={pageContainerRef}
      title={titletext}
      titleLeftSlot={
        threeLevelLinkageLanguage ? (
          <div
            style={{
              marginLeft: "40px",
              width: `${pureWidth - 50 - countCharacters(titletext)}px`,
            }}
          >
            {/* {buttonTextRef && buttonTextRef.current} */}
            <ServiceTabs
              threeLevelLinkageLanguage={threeLevelLinkageLanguage}
              actionCallback={tabChange}
              businessType={"bing"}
              onNodata={() => {
                setResCode("20090");
              }}
            />
          </div>
        ) : (
          ""
        )
      }
      titleRightSlot={bottomBtns}
    >
      <Spin spinning={loading} style={{ height: "100%" }}>
        <ComposeTreeTable
          memoryAction={false}
          ref={tableRef}
          key={renderKey}
          layout="Horizontal"
          formConfig={{
            blockData: formBlockData,
            showReset: true,
            // bottomSlot: <div className="flex justify-end mb-[10px]">{bottomBtns}</div>,
            extraProps: {
              formMounted() {
                tableRef.current?.formMethods?.setFieldDataSource(
                  "autoAccept",
                  [
                    { label: t(CommonEnum.YES, { ns: "Common" }), value: 1 },
                    { label: t(CommonEnum.NO, { ns: "Common" }), value: 0 },
                  ]
                );
                tableRef.current?.formMethods?.setFieldDataSource(
                  "openStatus",
                  [
                    { label: t(CommonEnum.YES, { ns: "Common" }), value: 1 },
                    { label: t(CommonEnum.NO, { ns: "Common" }), value: 0 },
                  ]
                );
              },
            },
          }}
          tableConfig={{
            defaultPageSize: 10,
            blockData: tableBlockData as any,
            columns: tableColumns,
            rowKey: "dataId",
            pureWidth: pureWidth,
            showOperationColumn: true,
            extraProps: {
              locale: {
                emptyText: noData,
              },
            },
            operationColumnProps: {
              outsideBtnCount: 1,
              width: 100,
              extraButtonRender: (record: any) => {
                return [
                  !record.businesses || record.businesses.length <= 0 ? (
                    <Button
                      size="small"
                      type="link"
                      onClick={() => {
                        onOpenBind(record);
                      }}
                    >
                      {t("takeaway.btnAuthManage", { ns: "Takeaway" })}
                    </Button>
                  ) : null,
                ];
              },
            },
          }}
          actionCallback={actionCallback}
        />
      </Spin>

      <MeituanBind
        shopTitle={shopTitle}
        ref={meituanBindRef}
        title={t("Takeaway.MeituantakeawayAuthorizationbinding", {
          ns: "Takeaway",
        })}
        height="300px"
        onChange={(params: any) => {
          console.log("ddddd", params);
          if (
            params &&
            ["keeta"].includes(params.record.channel) &&
            params.authType == "creatable"
          ) {
            let _params = _.cloneDeep(params);
            const { record, merchants } = _params;
            _params = {
              record: record,
              isShop: true,
              selectBusiness: record.business,
              channel: record.channel,
              merchants: merchants,
              authType: "merchants",
              current: 1,
              selectNode: {
                channel: record.channel,
              },
            };
            GeneralBindOnchange(_params);
          } else {
            // 绑定成功
            fetchData();
          }
        }}
      />
      <ElementBind
        shopTitle={shopTitle}
        ref={elemeBindRef}
        onAuth={() => {
          getTypeAuth();
        }}
        onChange={() => {
          // 绑定成功
          fetchData();
        }}
      />
      <AbroadBind
        shopTitle={shopTitle}
        ref={abroadBindRef}
        onChange={() => {
          fetchData();
        }}
        typeObj={typeObj}
      />
      <CandaoBind
        ref={candaoBindRef}
        onChange={() => {
          fetchData();
        }}
        typeObj={typeObj}
      />

      <DischargeModel
        shopTitle={shopTitle}
        ref={DischargeRef}
        onChange={() => {
          fetchData();
        }}
        typeObj={typeObj}
      />

      <BusinessSet
        ref={BusinessSetref}
        onChange={() => {
          fetchData();
        }}
      />

      {threeLevelLinkageLanguage ? (
        <GeneralBind
          shopTitle={shopTitle}
          ref={GeneralBindRef}
          onDischarge={(params: any) => {
            const { data, el, channelObj, record, label } = params;
            DischargeRef.current?.open({
              url: data ? data?.authUrl : "",
              record: record,
              authId: el.authId,
              channelObj,
              params,
              merchants: el,
              label: label,
            });
          }}
          threeLevelLinkageLanguage={threeLevelLinkageLanguage}
          onChange={GeneralBindOnchange}
          onCloseBing={() => {
            fetchData();
          }}
        />
      ) : (
        ""
      )}
    </PageContainer>
  );
};

export default View;
