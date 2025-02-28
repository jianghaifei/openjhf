import { message, Button, Tabs, Popconfirm, Tooltip } from "antd";
import { ILoaderData } from "@src/Router/GenerateRoutes";
import { useLoaderData } from "react-router-dom";
import { useEffect, useMemo, useRef, useState } from "react";
import { useTranslation } from "react-i18next";
import PageContainer from "@src/Components/Layouts/PageContainer";
import useCustomNavigate from "@src/Hooks/useCustomNavigate";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
} from "@restosuite/field-components";
import { useStore } from "@src/Store";

import ConfimModel from "@src/pages/Takeaway/StoreBinding/Components/ConfimModel";
import {
  deliveryQuery,
  deliveryRemove,
  deliveryQueryConfigs,
  deliveryRemoveConfigs,
  deliverySaveConfigs,
} from "@src/Api/Takeaway/AggregateManagement";
import { threeLevelLinkageQuery } from "@src/Api/Takeaway/StoreAndItems";
import _ from "lodash";
import styles from "./Components/index.module.less";
import { ShopSelector } from "@restosuite/panda";
import RuleModal from "./Components/RuleModal";

const Aggregate = () => {
  const { dispatchNavigate } = useCustomNavigate();
  const { pageUtils } = useLoaderData() as ILoaderData;
  const tableRef = useRef<any>(null);
  const { t, i18n } = useTranslation();
  const pageContainerRef = useRef<any>(null);
  const confimModelref = useRef<any>(null);
  const { loginStore } = useStore();
  const userInfo = loginStore.getUserInfo();
  const [type, setType] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(false);
  const [tableBlockData, setTableBlockData] = useState<any>({});
  const [formBlockData, setFormBlockData] = useState<any>({});
  const [pureWidth, setPsureWidth] = useState<number>(0);
  const [resCode, setResCode] = useState<any>();
  const isShop = userInfo?.orgType === "7";
  const titletext = t("aggregate.distributionrulemanagement", {
    ns: "Takeaway",
  }); // "配送规则管理"
  const [locationValue, setLocationValue] = useState();
  const [locationShow, setLocationShow] = useState(false);
  const RuleModalref = useRef<any>(null);
  const queryRef = useRef<any>(null);
  const tabRef = useRef<any>(null);
  const [currentRule, setCurrentRule] = useState("");
  const [threeLevelLinkageLanguage, setThreeLevelLinkageLanguage] =
    useState<any>(null);
  const QueryFormlocationblock = useMemo(() => {
    return pageUtils.getBlockData("QueryFormlocation");
  }, []);
  useEffect(()=>{
    console.log("这是新框架")
  },[])
  const getCustomLength = (str: string) => {
    let length = 0;
    for (const char of str) {
      if (char.charCodeAt(0) >= 0x4e00 && char.charCodeAt(0) <= 0x9fa5) {
        // 如果字符是汉字（根据汉字的Unicode范围），算作两个字符
        length += 2;
      } else {
        // 其他字符算作一个字符
        length += 1;
      }
    }
    return length;
  };

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
    tabChange("0");
  }, []);

  const TableCtl = (child: any) => {
    if (typeof child == "string") {
      if (getCustomLength(child) < 14) {
        return <div className={styles.tableAlignment}>{child}</div>;
      }
      return (
        <Tooltip placement="top" title={child}>
          <div className={styles.tableAlignment}>{child}</div>
        </Tooltip>
      );
    }
    return <div className={styles.tableAlignment}>{child}</div>;
  };

  const tableColumns: any = () => {
    return [
      {
        dataIndex: "ruleId",
        sorter: (a: any, b: any) => a.ruleId.localeCompare(b.ruleId),
        render: (value: number, record: any) => {
          return value;
        },
      },
      {
        dataIndex: "shopId",
        sorter: (a: any, b: any) => a.shopId.localeCompare(b.shopId),
        render: (value: number, record: any) => {
          return value;
        },
      },
      {
        dataIndex: "priorityDelivery",
        render: (value: number, record: any) => {
          return (
            (record.channels && record.channels.map((el: any) => el.channel)) ||
            []
          ).join("，");
        },
      },
      {
        dataIndex: "dispatchPriority",
        render: (value: number, record: any) => {
          return (
            (record.channels && record.channels.map((el: any) => el.channel)) ||
            []
          ).join("，");
        },
      },
      {
        dataIndex: "noticeFlag",
        render: (value: number, record: any) => {
          if (value == 1) {
            return `${record.expireMinutes}${t("aggregate.minutes", {
              ns: "Takeaway",
            })}`;
          } else {
            return "关闭";
          }
        },
      },
    ];
  };

  const tabChange = (evt: any) => {
    setType(evt);
    tabRef.current = evt;
    // 更新查询搜索
    tableRef.current?.removeMemoryAction();
    let blockData: any = {};
    let formData: any = {};

    if (evt == "1") {
      formData = QueryFormlocationblock;
      console.log("ddddddd", formData);
      const _formData = _.cloneDeep(formData);
      const customField = pageUtils.getBlockData("QueryFormlocationCom");
      _formData.fields.unshift({
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
      formData = _formData;
      blockData = pageUtils.getBlockData("locationTable");
    } else {
      formData = pageUtils.getBlockData("QueryForm");
      blockData = pageUtils.getBlockData("TableList");
    }
    if (blockData?.fields && blockData.fields.length > 0) {
      blockData.tableConfig = {
        type: "table",
        operationColumnConfig: {},
        columnConfig: blockData?.fields.map((item: any) => {
          let width = 130;
          if (["ruleId"].includes(item.fieldId)) {
            width = 200;
          }
          return {
            id: item.fieldId,
            minWidth: width,
          };
        }),
      };
      blockData.fields = blockData.fields.filter(
        (el: any) => el.fieldId != "mapCategoryName"
      );
    }

    setTableBlockData(blockData);

    setFormBlockData(formData);
  };

  const getPurwidth = () => {
    setPsureWidth(
      pageContainerRef?.current
        ? (pageContainerRef?.current?.getContentWidth() as number)
        : 0
    );
  };

  window.onresize = _.debounce(getPurwidth, 1);

  const actionCallback = (actios: IComposeTreeTableActionCallbackProps) => {
    const actionProps: IComposeTreeTableActionCallbackProps =
      _.cloneDeep(actios);
    getPurwidth();
    console.log("actionCallback", actionProps, queryRef.current);
    if (
      actionProps.formData.queryHasConfig ||
      actionProps.formData.queryHasConfig == "0"
    ) {
      actionProps.formData.queryConfigFlag =
        actionProps.formData.queryHasConfig;
    }
    if (actionProps.formData.combinedFields) {
      actionProps.formData[actionProps.formData.combinedFields.fieldId] =
        actionProps.formData.combinedFields.value;
    }
    queryRef.current = actionProps;
    fetchData();
  };

  const fetchData = (info?: any) => {
    console.log("aaaaaa", tabRef.current);
    setLoading(true);
    // deliveryQueryConfigs()
    const apiFetch =
      tabRef.current == "1" ? deliveryQueryConfigs : deliveryQuery;
    let queryConfigFlag = "0";
    if (
      queryRef.current &&
      queryRef.current.formData &&
      !queryRef.current.formData.queryHasConfig
    ) {
      queryConfigFlag = queryRef.current.formData.queryConfigFlag;
    }
    apiFetch({
      page: {
        pageNo: queryRef.current.pageNo,
        pageSize: queryRef.current.pageSize,
      },
      ...queryRef.current.formData,
      corporationId: loginStore.getCorporationId(),
      queryConfigFlag: queryConfigFlag || "0",
    })
      .then((res: any) => {
        setLoading(false);
        console.log("gggg", res);
        if (res.code != "000") return;
        const { page, deliveryRulesList } = res.data;
        const list = deliveryRulesList.map((el: any) => {
          return {
            ...el,
            ...el.rules,
            ...(el.rules && el.rules.dispatchTiming),
            ...(el.rules && el.rules.expireConfig),
            ...(el.rules && el.rules.expireVoiceConfig),
          };
        });
        tableRef.current?.setTableData(list);
        tableRef.current?.setPagination({
          pageNo: page.pageNo,
          pageSize: page.pageSize,
          total: page.total,
        });
      })
      .catch(() => {
        setLoading(false);
      });
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
    return null;
  }, [resCode]);

  const handleSelectLocations = (value: any, record: any) => {
    console.log("bbbbbb", value, record);
    if (value && value.locationData && currentRule) {
      const values = {
        corporationId: loginStore.getCorporationId(),
        shopIds: value.locationData.map((el: any) => el.id) || [],
        ruleId: currentRule,
      };
      setLoading(true);
      deliverySaveConfigs(values)
        .then((res: any) => {
          setLoading(false);
          console.log("ddddd", res);
          if (res.code != "000") {
            return;
          }
          message.success(res.msg);
          queryRef.current = { pageSize: 10, pageNo: 1 };
          fetchData();
        })
        .catch(() => {
          setLoading(false);
        });
    }
  };

  const getOrgId = () => {
    const userInfo = loginStore.getUserInfo();
    switch (userInfo?.orgType) {
      case "1":
        return userInfo?.brandId;
      case "0":
      case "7":
      default:
        return userInfo?.orgId || "";
    }
  };

  // 按钮
  const extraButton = (record: any) => {
    const btnsList: any = [];
    // 配送规则设置对应的操作按钮
    if (type == "0") {
      btnsList.push(
        <Button
          size="small"
          type="link"
          onClick={() => {
            dispatchNavigate("/aggregatemanagementEdit", {
              state: {
                record,
              },
            });
          }}
        >
          {t("aggregate.Edit", { ns: "Takeaway" })}
          {/* 编辑 */}
        </Button>
      );
      btnsList.push(
        <Button
          type="link"
          onClick={() => {
            setLocationShow(true);
            setCurrentRule(record.ruleId);
          }}
        >
          {t("aggregate.Applytostore", { ns: "Takeaway" })}
          {/* 应用到门店 */}
        </Button>
      );
      btnsList.push(
        <Popconfirm
          title={t(
            record.isArchived
              ? "common.cancel_archive_confirm"
              : "common.archive_confirm",
            {
              ns: "Common",
            }
          )}
          onConfirm={() => {
            setLoading(true);
            deliveryRemove({
              corporationId: loginStore.getCorporationId(),
              deliveryRules: {
                id: record.id,
                ruleId: record.ruleId,
              },
            })
              .then((res: any) => {
                setLoading(false);
                if (res.code != "000") {
                  return;
                }
                message.success(res.msg);
                queryRef.current = { pageSize: 10, pageNo: 1 };
                fetchData();
              })
              .catch(() => {
                setLoading(false);
              });
          }}
        >
          <Button size="small" type="link">
            {t(record.isArchived ? "common.cancel_archive" : "common.archive", {
              ns: "Common",
            })}
          </Button>
        </Popconfirm>
      );
    } else {
      btnsList.push(
        <Button
          size="small"
          type="link"
          onClick={() => {
            RuleModalref.current.open(record);
          }}
        >
          {t("aggregate.setrules", { ns: "Takeaway" })}
          {/* 设置规则 */}
        </Button>
      );
      if (record.rules) {
        btnsList.push(
          <Popconfirm
            title={t("aggregate.cancelSettings", { ns: "Takeaway" })}
            onConfirm={() => {
              setLoading(true);
              deliveryRemoveConfigs({
                id: record.id,
              })
                .then((res: any) => {
                  setLoading(false);
                  if (res.code != "000") {
                    return;
                  }
                  message.success(res.msg);
                  queryRef.current = { pageSize: 10, pageNo: 1 };
                  fetchData();
                })
                .catch(() => {
                  setLoading(false);
                });
            }}
          >
            <Button size="small" type="link">
              {t("aggregate.unset", { ns: "Takeaway" })}
              {/* 取消设置 */}
            </Button>
          </Popconfirm>
        );
      }
    }

    return btnsList;
  };

  const bottomContent = () => {
    return (
      <div
        className="flex justify-between mb-[10px]"
        style={{
          marginTop: "-6px",
          padding: "0 16px",
          overflow: "auto",
          width: pureWidth - (!isShop ? 240 + 45 : 30),
        }}
      ></div>
    );
  };

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
    return count;
  };

  return (
    <PageContainer
      title={titletext}
      ref={pageContainerRef}
      titleLeftSlot={
        <div
          style={{
            marginLeft: "40px",
            width: `${pureWidth - 100 - countCharacters(titletext) * 16}px`,
          }}
        >
          <Tabs
            items={[
              {
                key: "0",
                label: t("aggregate.distributionrulesetting", {
                  ns: "Takeaway",
                }), //"配送规则设置",
              },
              {
                key: "1",
                label: t("aggregate.storedeliveryrules", {
                  ns: "Takeaway",
                }), // "门店配送规则",
              },
            ]}
            defaultActiveKey={"0"}
            onTabClick={tabChange}
            className={styles.tabclass}
            tabPosition={"top"}
          />
        </div>
      }
      titleRightSlot={
        type == "0" && (
          <Button
            type="primary"
            onClick={() => {
              dispatchNavigate("/aggregatemanagementEdit");
            }}
          >
            {/* 新增配送规则 */}
            {t("aggregate.newshippingrules", { ns: "Takeaway" })}
          </Button>
        )
      }
    >
      <div style={{ height: "100%" }}>
        <ComposeTreeTable
          key={type}
          memoryAction={false}
          ref={tableRef}
          layout="Horizontal"
          formConfig={{
            blockData: formBlockData,
            showReset: true,
            showSearch: true,
            bottomSlot: !noData && resCode && bottomContent(),
            resetCallback: () => {
              queryRef.current = { pageSize: 10, pageNo: 1 };
              fetchData();
            },
          }}
          tableConfig={{
            blockData: tableBlockData,
            columns: tableColumns(),
            rowKey: type == "1" ? "shopId" : "ruleId",
            showOperationColumn: true,
            pureWidth: pureWidth - (!isShop ? 240 + 45 : 30),
            extraProps: {
              locale: {
                emptyText: noData,
              },
              loading: loading,
            },
            operationColumnProps: {
              outsideBtnCount: 3,
              width: 180,
              extraButtonRender: (record: any) => {
                return extraButton(record);
              },
            },
          }}
          actionCallback={actionCallback}
        />

        <ConfimModel ref={confimModelref} />

        <RuleModal
          ref={RuleModalref}
          onChange={() => {
            queryRef.current = { pageSize: 10, pageNo: 1 };
            fetchData();
          }}
        />

        <div style={{ display: "none" }}>
          <ShopSelector
            showModal={locationShow}
            closeModal={() => {
              setLocationShow(false);
            }}
            mode="locationBtn"
            disabled={true}
            needReset={true}
            noTagCheck={true}
            // countryList={countryList}
            // currencyList={currencyList}
            locationBtnTitle={""}
            locationBtnProps={{
              type: "link",
            }}
            corporationId={loginStore.getCorporationId()}
            orgId={
              loginStore.getUserInfo()
                ? loginStore.getUserInfo()?.orgId || ""
                : ""
            }
            orgType={
              loginStore.getUserInfo()
                ? loginStore.getUserInfo()?.orgType || ""
                : ""
            }
            token={loginStore.getToken() || ""}
            onChange={handleSelectLocations}
            value={locationValue}
            language={i18n.language}
            id={getOrgId()}
            employeeId={loginStore.getUserInfo()?.employeeCode}
            organizationId={loginStore.getUserInfo()?.orgId}
            orgTypeList={[1]}
          />
        </div>
      </div>
    </PageContainer>
  );
};

export default Aggregate;
