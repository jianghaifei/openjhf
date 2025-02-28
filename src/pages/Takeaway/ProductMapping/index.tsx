import {
  Switch,
  message,
  Button,
  Space,
  Modal,
  Dropdown,
  Image,
  Spin,
  Tooltip,
} from "antd";
import { IKVProps } from "@restosuite/field-core";
import { DownOutlined } from "@ant-design/icons";
import { ILoaderData } from "@src/routes/GenerateRoutes";
import { useLoaderData } from "react-router-dom";
import { useEffect, useMemo, useRef, useState, useCallback } from "react";
import { useTranslation } from "react-i18next";
import PageContainer from "@src/Components/Layouts/PageContainer";
import useCustomNavigate from "@src/Hooks/useCustomNavigate";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
} from "@restosuite/field-components";
import { useStore } from "@src/Store";
import ServiceTabs from "../Components/ServiceTabs";
import { queryShopListByEmployeeId } from "@src/Api/Common/Performance";
import { parseFlatDataToTreeData } from "@src/Utils/CommonUtils";
import TakeawayMenus from "./Components/TakeawayMenus";
import MenuItems from "./Components/MenuItems";
import SyncDeleteModal from "./Components/SyncDeleteModal";
import BatchBindModal from "./Components/BatchBindModal";
import PushThirdModal from "./Components/PushThirdModal";
import ThirdItemsLoad from "./Components/ThirdItemsLoad";
import CopyShopModal from "./Components/CopyShopModal";

import ConfimModel from "@src/pages/Takeaway/StoreBinding/Components/ConfimModel";
import {
  changeOperateShop,
  batchItemStatus,
  upBatchItemStatus,
  queryOptionResult,
  threeLevelLinkageQuery,
  shopQueryShop,
} from "@src/Api/Takeaway/StoreAndItems";
import { rootStore } from "@src/Store";
import { getMenuTree } from "@src/Api/Item/Menu";
import { getCurrencySymbol } from "@src/Utils/CommonUtils";
import StatusTag from "./Components/StatusTag";
import _ from "lodash";
import {
  getMapdata,
  bindAndUnbind,
  situationsCheck,
} from "../Components/IHelper";
import { itemSwitch, trdItemQuery } from "@src/Api/Takeaway/takeoutDelivery";
import styles from "./Components/index.module.less";
import { useTabActive } from "@restosuite/fe-skeleton";

const View = () => {
  const { dispatchNavigate } = useCustomNavigate();
  const { pageUtils } = useLoaderData() as ILoaderData;
  const tableRef = useRef<any>(null);
  const { t, i18n } = useTranslation();
  const pageContainerRef = useRef<any>(null);
  const menuModalRef = useRef<any>(null);
  const [renderKey, setRenderKey] = useState<string>("");
  const menuItemModalRef = useRef<any>(null);
  const syncDeleteModalRef = useRef<any>(null);
  const batchModalRef = useRef<any>(null);
  const pushModalRef = useRef<any>(null);
  const timeOutRef = useRef<any>(null);
  const confimModelref = useRef<any>(null);
  const { loginStore } = useStore();
  const userInfo = loginStore.getUserInfo();
  const [type, setType] = useState<string>("");
  const [typeObj, setTypeObj] = useState<IKVProps>({});
  const [offsetHeight, setoffsetHeight] = useState<any>();
  const [menuStatus, setMenuStatus] = useState<string>("delete");
  const [menuInfo, setMenuInfo] = useState<IKVProps>({});
  const [menuTree, setMenuTree] = useState<IKVProps[]>([]);
  const [authInfo, setAuthInfo] = useState<IKVProps>({});
  const [operaLoading, setOperaLoading] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const [unBindLoading, setUnBindLoading] = useState<boolean>(false);
  const [notBindCount, setNoBindCount] = useState<string>("0");
  const [noBindLoad, setNoBindLoad] = useState<boolean>(false);
  const [tableBlockData, setTableBlockData] = useState<any>(null);
  const [selectedRowKeys, setSelectedRowKeys] = useState<any[]>([]);
  const [threeLevelLinkageLanguage, setThreeLevelLinkageLanguage] =
    useState<any>(null);
  const [pureWidth, setPsureWidth] = useState<number>(0);
  const [resCode, setResCode] = useState<any>();
  const [total, setTotal] = useState<any>();
  const tableDataRef = useRef<any[]>([]);
  const selectRowsRef = useRef<any[]>([]);
  const copyShopref = useRef<any>(null);
  const shopIdref = useRef<any>({ shopId: userInfo?.shopId || null });
  const isShop = userInfo?.orgType === "7";
  const [selectedtreeKeys, setSelectedtreeKeys] = useState<any[]>([]);
  const [expendtreeKeys, setExpendtreeKeys] = useState<any[]>([]);
  // const [isRender, setIsRender] = useState(false);
  const [isShowSearch, setIsShowSearch] = useState(true);
  const [renderCompos, setRenderCompos] = useState(true);
  const titletext = t("product.bindTitle", { ns: "Takeaway" });
  const [treeSearchKeyword, setTreeSearchKeyword] = useState<string>("");
  const queryRef = useRef<IKVProps>({
    platform: null,
    channel: null,
    treeRow: {
      orgType: userInfo?.orgType,
      organizationId: userInfo?.orgId,
      name: userInfo?.orgName,
    },
  });
  const [queryParams, setQueryParams] = useState<IKVProps>(queryRef.current);
  const [treeConfig, setTreeConfig] = useState<any>({});

  const formBlockData = useMemo(() => {
    let blockData: any = pageUtils.getBlockData("QueryForm");
    if (situationsCheck(typeObj.channel, "inSide")) {
      blockData = pageUtils.getBlockData("QueryElemeForm");
      setTimeout(() => {
        tableRef.current?.formMethods?.setFieldDataSource("bindStatus", [
          {
            value: true,
            label: t("product.bindStatusYes", { ns: "Takeaway" }),
          },
          {
            value: false,
            label: t("product.bindStatusNo", { ns: "Takeaway" }),
          },
        ]);
      });
    }
    const customField = pageUtils.getBlockData("QueryFormCustomField");
    if (
      blockData?.fields &&
      !blockData?.fields.find((o: any) => o.fieldId == "combinedFields")
    ) {
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
    }
    return blockData;
  }, [pageUtils, typeObj, type]);

  const syncStatusOptions = useMemo(() => {
    const blockData: any = tableBlockData || {};
    const options = blockData.fields?.find(
      (item: any) => item.fieldId === "syncStatus"
    )?.data?.dataSource;
    return options || [];
  }, [tableBlockData]);

  const itemTypeOptions = useMemo(() => {
    const blockData: any = tableBlockData || {};
    const options = blockData.fields?.find(
      (item: any) => item.fieldId === "itemType"
    )?.data?.dataSource;
    return options || [];
  }, [tableBlockData]);

  // 检查字段是否变动，详情参见https://saturn.universe.restosuite.ai/venus-product?venus-product=/venus/iteration/product/P01HT44Y506M4ZKEFME8Q7WEZVH/iteration/task-detail/333327
  const isUpdateObj: any = {
    itemName: "trdItemName",
    itemSizeName: "trdItemSizeName",
    menuGroupName: "trdCategoryName",
    skuId: "trdSkuId",
    price: "trdPrice",
    itemType: "trdItemType",
    itemImage: "trdItemImage",
  };
  useEffect(() => {
    console.log("这是新框架");
  }, []);
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

  const checkIsUpdate = (record: IKVProps, key: string) => {
    const toKey = isUpdateObj[key];

    // 不影响范围：美饿抖 是商品绑定的关系，没这个逻辑 HP、UP、chowly有这逻辑
    if (
      ["chowly", "urbanPiper", "grab", "hungryPanda"].indexOf(typeObj.channel) <
      -1
    ) {
      return false;
    }
    // 非未同步，不参与比对
    if (record?.syncStatusValue !== "NOT_SYNCED") {
      return false;
    }
    if (!record[toKey] || record[toKey] === "-") {
      return false;
    }
    if (record[key] != record[toKey]) {
      return true;
    }
    return false;
  };

  useTabActive(() => {
    setRenderKey(`${Math.random()}`);
    setTableBlockData(null);
  });

  useEffect(() => {
    if (type && typeObj) {
      let key = true;
      if (typeObj.channel == "chowly") {
        setIsShowSearch(false);
        key = false;
      } else {
        setIsShowSearch(true);
        key = true;
      }
    }
  }, [type, typeObj]);

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
    const totalColumns: any = [
      {
        dataIndex: "itemName",
        render(value: string, record: any) {
          return (
            <div
              className={`${
                checkIsUpdate(record, "itemName") ? "text-[#FF2F2F]" : ""
              }`}
            >
              {TableCtl(value)}
            </div>
          );
        },
      },
      {
        dataIndex: "itemSizeName",
        render(value: string, record: any) {
          return (
            <div
              className={`${
                checkIsUpdate(record, "itemSizeName") ? "text-[#FF2F2F]" : ""
              }`}
            >
              {TableCtl(value)}
            </div>
          );
        },
      },
      {
        dataIndex: "menuGroupName",
        render(value: string, record: any) {
          return (
            <div
              className={`${
                checkIsUpdate(record, "menuGroupName") ? "text-[#FF2F2F]" : ""
              }`}
            >
              {TableCtl(value)}
            </div>
          );
        },
      },
      {
        dataIndex: "skuId",
        render(value: string, record: any) {
          return (
            <div
              className={`${
                checkIsUpdate(record, "skuId") ? "text-[#FF2F2F]" : ""
              }`}
            >
              {value}
            </div>
          );
        },
      },
      {
        dataIndex: "price",
        render(value: string, record: any) {
          return (
            <div
              className={`${
                checkIsUpdate(record, "price") ? "text-[#FF2F2F]" : ""
              }`}
            >
              {getCurrencySymbol()}
              {value}
            </div>
          );
        },
      },

      {
        dataIndex: "itemType",
        render(value: string, record: any) {
          const val = value === "Single" ? "Item" : value;
          const label =
            itemTypeOptions.find((child: any) => child.value === val)
              ?.languageData[i18n.language] || value;
          return (
            <div
              className={`${
                checkIsUpdate(record, "itemType") ? "text-[#FF2F2F]" : ""
              }`}
            >
              {label}
            </div>
          );
        },
      },
    ];
    const outSide: any = [
      {
        dataIndex: "trdItemName",
        render(value: any, record: any) {
          return TableCtl(value || "-");
        },
      },
      {
        dataIndex: "trdItemSizeName",
        render(value: any, record: any) {
          return TableCtl(value || "-");
        },
      },
      {
        dataIndex: "trdSubMenuName",
        render(value: any, record: any) {
          return TableCtl(value || "-");
        },
      },
      {
        dataIndex: "trdSkuId",
        render(value: any, record: any) {
          return TableCtl(value || "-");
        },
      },
      {
        dataIndex: "syncStatus",
        render(value: string, record: any) {
          const label =
            syncStatusOptions.find((child: any) => child.value === value)
              ?.languageData[i18n.language] || "";
          return <StatusTag value={value} label={label} />;
          // return value;
        },
      },
      {
        dataIndex: "itemImage",
        render(value: string, record: any) {
          return TableCtl(
            value ? (
              <div
                className={`${
                  checkIsUpdate(record, "price")
                    ? "border-[#FF2F2F] border-1 border-dashed p-[5px] inline-block"
                    : ""
                }`}
              >
                <Image width={35} src={value} />
              </div>
            ) : (
              "-"
            )
          );
        },
      },
      {
        dataIndex: "trdPrice",
        render(value: string, record: any) {
          return (
            <div
              className={`${
                checkIsUpdate(record, "trdPrice") ? "text-[#FF2F2F]" : ""
              }`}
            >
              {TableCtl(value ? `${getCurrencySymbol()}${value}` : "-")}
            </div>
          );
        },
      },
      {
        dataIndex: "trdItemImage",
        render(value: string, record: any) {
          return TableCtl(value ? <Image width={35} src={value} /> : "-");
        },
      },
      {
        dataIndex: "trdItemType",
        render(value: string, record: any) {
          const val = value === "Single" ? "Item" : value;
          const label =
            itemTypeOptions.find((child: any) => child.value === val)?.label ||
            value;
          return (
            <div
              className={`${
                checkIsUpdate(record, "trdItemType") ? "text-[#FF2F2F]" : ""
              }`}
            >
              {TableCtl(label)}
            </div>
          );
        },
      },
      {
        dataIndex: "itemStatus",
        render(value: string, record: any) {
          return (record.itemStatus === 1 || record.itemStatus === 0) &&
            ["chowly"].indexOf(typeObj.channel) < 0 ? (
            <Space>
              {/* 已上架/已下架 */}
              {record.itemStatus === 1
                ? t("product.statusOnSelf", { ns: "Takeaway" })
                : t("product.statusOffSelf", { ns: "Takeaway" })}
              <Switch
                loading={operaLoading}
                checked={!!record.itemStatus}
                onChange={(evt: any) => {
                  confimModelref.current.open({
                    title: "",
                    icon: "",
                    width: 500,
                    buttonText: "",
                    buttonList: [
                      <Button
                        type="default"
                        onClick={() => {
                          confimModelref.current.destroy();
                        }}
                      >
                        {t("mainBranch.cancelInfo", { ns: "Financial" })}
                      </Button>,
                      <Button
                        type="primary"
                        onClick={() => {
                          let id = record.itemId;
                          const itemPaths: string[] = [];
                          if (
                            situationsCheck(queryRef.current?.channel, "inSide")
                          ) {
                            id = record?.id;
                          }
                          if (
                            [
                              "urbanPiper",
                              "grab",
                              "foodPanda",
                              "fantuan",
                              "deliveroo",
                              "keeta",
                            ].indexOf(queryRef.current?.channel) > -1
                          ) {
                            itemPaths.push(record?.itemPath);
                          }
                          if (record.itemType == "Item" && record.skuId) {
                            batchSetMenuStatus([id], evt, itemPaths, [
                              record.skuId,
                            ]);
                          } else {
                            batchSetMenuStatus([id], evt, itemPaths, []);
                          }
                          confimModelref.current.destroy();
                        }}
                      >
                        {t("common.confirm", { ns: "Common" })}
                      </Button>,
                    ],
                    textTitle: `${
                      evt
                        ? t("Takeaway.confirmShelf", { ns: "Takeaway" })
                        : t("Takeaway.confirmUnshelf", { ns: "Takeaway" })
                    }?`,
                  });
                }}
              ></Switch>
            </Space>
          ) : (
            "-"
          );
        },
      },
    ];
    const home: any = [
      {
        dataIndex: "syncStatus",
        render(value: any, record: any) {
          return value && value != "-"
            ? value instanceof Array
              ? value.map((el: any) => {
                  const label =
                    syncStatusOptions.find((child: any) => child.value === el)
                      ?.languageData[i18n.language] || "";
                  return (
                    <div>
                      <StatusTag value={value} label={label} />
                    </div>
                  );
                })
              : value
            : "-";
        },
      },
      {
        dataIndex: "itemImage",
        render(value: string, record: any) {
          return TableCtl(
            <div className={styles.tableAlignment}>
              {record.image ? (
                <div
                  className={`${
                    checkIsUpdate(record, "price")
                      ? "border-[#FF2F2F] border-1 border-dashed p-[5px] inline-block"
                      : ""
                  }`}
                >
                  <Image width={35} src={record.image} />
                </div>
              ) : (
                "-"
              )}
            </div>
          );
        },
      },
      {
        dataIndex: "bindStatus",
        render(value: string, record: any) {
          return <StatusTag value={record.bindStatusValue} label={value} />;
        },
      },
      {
        dataIndex: "trdItemImage",
        render(value: any, record: any) {
          return value && value != "-"
            ? value instanceof Array
              ? value.map((el: any) =>
                  TableCtl(el ? <Image width={35} src={el} /> : "-")
                )
              : value
            : "-";
        },
      },
      {
        dataIndex: "trdItemName",
        render(value: any, record: any) {
          return value && value != "-"
            ? value instanceof Array
              ? value.map((el: any) => TableCtl(el || "-"))
              : value
            : "-";
        },
      },
      {
        dataIndex: "trdItemSizeName",
        render(value: any, record: any) {
          return record.trdUnitName && record.trdUnitName != "-"
            ? record.trdUnitName.map((el: any) => TableCtl(el || "-"))
            : "-";
        },
      },
      {
        dataIndex: "trdItemType",
        render(value: any, record: any) {
          return value && value != "-"
            ? value instanceof Array
              ? value.map((el: any) =>
                  TableCtl(
                    itemTypeOptions.find((child: any) => child.value === el)
                      ?.label ||
                      el ||
                      "-"
                  )
                )
              : value
            : "-";
        },
      },
      {
        dataIndex: "trdSubMenuName",
        render(value: any, record: any) {
          return record.trdCategoryName && record.trdCategoryName != "-"
            ? record.trdCategoryName.map((el: any) => TableCtl(el || "-"))
            : "-";
        },
      },
      {
        dataIndex: "trdPrice",
        render(value: any, record: any) {
          return value && value != "-"
            ? value instanceof Array
              ? value.map((el: any) =>
                  TableCtl(`${getCurrencySymbol()}${el || "-"}`)
                )
              : value
            : "-";
        },
      },

      {
        dataIndex: "itemStatus",
        render(value: any, record: any) {
          return record.trdStatus && record.trdStatus != "-"
            ? record.trdStatus.map((el: any, index: number) =>
                TableCtl(
                  <Space>
                    {el === 1
                      ? t("product.statusOnSelf", { ns: "Takeaway" })
                      : t("product.statusOffSelf", { ns: "Takeaway" })}
                    <Switch
                      loading={operaLoading}
                      checked={el == "1" ? true : false}
                      onChange={(evt: any) => {
                        const text =
                          ["meituanMerchant", "meituan"].indexOf(
                            queryRef.current?.channel
                          ) > -1
                            ? evt
                              ? ""
                              : t("instant.associatedMeituansynchronized", {
                                  ns: "Takeaway",
                                })
                            : "";
                        const textTitle = evt
                          ? t("Takeaway.confirmShelf", { ns: "Takeaway" }) + "?"
                          : t("Takeaway.confirmUnshelf", { ns: "Takeaway" }) +
                            "?";

                        confimModelref.current.open({
                          title: "",
                          icon: "",
                          width: 500,
                          buttonText: "",
                          buttonList: [
                            <Button
                              type="default"
                              onClick={() => {
                                confimModelref.current.destroy();
                              }}
                            >
                              {t("mainBranch.cancelInfo", { ns: "Financial" })}
                            </Button>,
                            <Button
                              type="primary"
                              onClick={() => {
                                const on = [];
                                const off = [];
                                const data = {
                                  trdItemId: record.trdItemId[index],
                                  trdUnitId: record.trdUnitId[index],
                                };
                                if (evt) {
                                  on.push(data);
                                }

                                if (!evt) {
                                  off.push(data);
                                }
                                setOperaLoading(true);
                                unmountChange(authInfo.id, on, off);
                                confimModelref.current.destroy();
                              }}
                            >
                              {t("common.confirm", { ns: "Common" })}
                            </Button>,
                          ],
                          textTitle: textTitle,
                          text: text,
                        });
                      }}
                    ></Switch>
                  </Space>
                )
              )
            : "-";
        },
      },
    ];

    // 国内
    if (situationsCheck(queryRef.current?.channel, "inSide", [], ["keeta"])) {
      return [...home, ...totalColumns];
    } else {
      // 国外
      return [...outSide, ...totalColumns];
    }
  };

  const tabChange = (evt: any) => {
    console.log("======", evt);
    setTableBlockData(null);
    // 更新查询搜索
    tableRef.current?.removeMemoryAction();
    selectRowsRef.current = [];
    setSelectedRowKeys([]);
    if (timeOutRef.current) {
      setOperaLoading(false);
      clearTimeout(timeOutRef.current);
    }

    // if (!isShop) {
    //   queryRef.current = {};
    //   setQueryParams({});
    // }
    const userInfo = rootStore.loginStore.getUserInfo();

    queryRef.current = {
      ...queryRef.current,
      platform: evt.key,
      channel: evt.channel,
      corporationId: userInfo?.corporationId,
    };
    if (!queryRef.current.page) {
      queryRef.current.page = {};
    }
    queryRef.current.page.pageNo = 1;
    queryRef.current.page.pageSize = 10;
    setType(evt.key);
    setTypeObj(evt);
    // if (isRender) {
    //   queryRef.current.trd = {};
    //   queryRef.current.itemFilter = {};
    //   tableRef.current?.formMethods.reset();
    //   // setQueryParams(queryRef.current);
    //   console.log("bbbb4444");
    //   // loadDate(evt);
    // }
    queryRef.current.trd = {};
    queryRef.current.itemFilter = {};
    tableRef.current?.formMethods.reset();
    // setQueryParams(queryRef.current);
    setRenderKey(evt.key);
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
    // setIsRender(true);

    console.log("actionCallback", actios);
    // 对组合式筛选项做处理
    if (actionProps.formData?.combinedFields) {
      actionProps.formData[actionProps.formData.combinedFields?.fieldId] =
        actionProps.formData.combinedFields?.value;
      delete actionProps.formData.combinedFields;
    }
    const actionParams: any = {
      ...queryRef.current,
      page: {
        pageNo: actionProps.pageNo || 1,
        pageSize: actionProps.pageSize || 10,
      },
      ...actionProps.formData,
    };
    // console.log("aaa111", actionParams);
    actionParams.itemFilter = {};
    actionParams.trd = {};

    const convertKeys: any = {
      itemName: "itemNameLike",
      itemStatus: "onShelf",
      syncStatus: "binding",
      bindStatus: "binding",
      trdItemName: "trdItemNameLike",
    };
    if (actionProps.formData && actionProps.formData.itemStatus) {
      actionProps.formData.trdItemStatus =
        actionProps.formData.itemStatus == "on_shelf" ? 1 : 0;
    }

    if (
      actionProps.formData &&
      (actionProps.formData.bindStatus == true ||
        actionProps.formData.bindStatus == false)
    ) {
      actionProps.formData.isMapped = actionProps.formData.bindStatus;
    }

    Object.keys(actionProps.formData as any[]).forEach((key: string) => {
      let val = (actionProps.formData as any)[key];
      let newKey = key;
      // eleme hungryPanda的，要转换下参数
      if (
        situationsCheck(
          queryRef.current?.channel,
          "inSide",
          [],
          ["urbanPiper", "grab", "foodPanda", "fantuan", "deliveroo", "keeta"]
        )
      ) {
        newKey = convertKeys[key] || key;
        if (newKey === "binding") {
          val = val === "SYNCED" ? true : false;
        } else if (newKey === "onShelf") {
          val = val === "on_shelf" ? true : false;
        }
      }

      actionParams.itemFilter[newKey] = val;
      actionParams.trd[newKey] = val;
      actionParams[newKey] = val;
    });

    if (actionProps.treeRows && actionProps.treeRows.length > 0) {
      if (actionProps.treeRows[0]?.orgType === 7) {
        actionParams.treeRow = actionProps.treeRows[0];
        actionParams.shopId = actionProps.treeRows[0]?.businessId;
        shopIdref.current.shopId = actionProps.treeRows[0]?.businessId;

        if (["0", "1"].includes(userInfo.orgType)) {
          sessionStorage.setItem(
            "takouttreeRows",
            JSON.stringify(actionProps.treeRows[0])
          );
        }
      } else {
        actionParams.shopId = null;
        actionParams.treeRow = null;
        setResCode(null);
      }
      setExpendtreeKeys([actionProps.treeRows[0].parentId]);
      setSelectedtreeKeys([actionProps.treeRows[0].dataId]);
    }

    queryRef.current = actionParams;
    loadDate(typeObj);
  };

  const loadDate = (evt?: any) => {
    if (evt) {
      queryRef.current.platform = evt.key;
      queryRef.current.shopId = shopIdref.current.shopId;
    }
    if (queryRef.current.platform) {
      getShopBindStatus(evt);
    }
  };

  // 获取外卖菜单列表
  useEffect(() => {
    if (queryRef.current?.shopId && queryRef.current?.platform) {
      getMenuList();
    }
  }, [queryParams.shopId, queryParams.platform]);

  // 获取外卖菜单列表
  const getMenuList = () => {
    const menuItem = queryRef.current.treeRow || {};
    const params: any = {
      menuChannel: "menu.channel.third_party",
      isArchived: false,
    };
    if (userInfo?.orgType === "0" || userInfo?.orgType === "1") {
      params.targetOrgId = menuItem.organizationId;
      params.targetOrgType = menuItem.orgType;
    }
    getMenuTree(params)
      .then((res: any) => {
        const { code, data = {} } = res;
        if (code === "000") {
          setMenuTree(data.menus || []);
        }
      })
      .catch((err) => {
        setMenuTree([]);
      });
  };

  // 获取门店授权状态
  const getShopBindStatus = (
    evt?: any,
    actionParams?: any,
    isPiliang?: boolean
  ) => {
    setTableNoData();
    const userInfo = rootStore.loginStore.getUserInfo();
    if (!(actionParams && actionParams.shopId) && !queryRef.current?.shopId) {
      return;
    }
    setLoading(true);
    shopQueryShop({
      business: "takeOut",
      shopId:
        actionParams && actionParams.shopId
          ? actionParams.shopId
          : queryRef.current?.shopId,
      platform: evt ? evt.key : queryRef.current?.platform,
    })
      .then((res: any) => {
        setLoading(false);
        if (res.code == "000") {
          // 如果没绑定 res.data.length == 0
          if (res.data && res.data.length == 1) {
            const data = res.data[0] || {};
            if (evt) {
              const nevt = _.cloneDeep(evt);
              if (data && data.channel) {
                queryRef.current = {
                  ...queryRef.current,
                  platform: data.platform,
                  channel: data.channel,
                  corporationId: userInfo?.corporationId,
                };
                nevt.channel = data.channel;
                setTypeObj(nevt);
              } else {
                queryRef.current = {
                  ...queryRef.current,
                  platform: nevt.key,
                  channel: nevt.channel,
                  corporationId: userInfo?.corporationId,
                };
                setTypeObj(nevt);
              }
              console.log("data.channel", data.channel, evt, queryRef.current);
            }

            setQueryParams(queryRef.current);

            setAuthInfo(data || {});
            // 判断是否绑定了菜单，绑定了再去调用列表
            if (data.selectedMenuId) {
              setMenuInfo({
                menuId: data.selectedMenuId,
                menuName: data.selectedMenuName,
                id: data.id,
              });
              queryRef.current.menuId = data.selectedMenuId || "";
              queryRef.current.trd.channelShopId = data.id;
              queryRef.current.trd.needInfo = true;
              fetchData();
            } else {
              setResCode(20009);
              setLoading(false);
              setMenuInfo({
                id: data.id,
              });
            }
          } else {
            setResCode(20010);
            setLoading(false);
          }
        } else {
          setLoading(false);
        }

        // 获取table的json
        if (!tableBlockData) {
          let blockData = pageUtils.getBlockData("TableList");
          if (situationsCheck(queryRef.current.channel, "inSide", ["keeta"])) {
            blockData = pageUtils.getBlockData("ElemeTableList");
          }
          if (blockData?.fields && blockData.fields.length > 0) {
            blockData.tableConfig = {
              type: "table",
              operationColumnConfig: {},
              columnConfig: blockData?.fields.map((item: any) => {
                let width = 130;
                if (["trdSkuId", "skuId"].includes(item.fieldId)) {
                  width = 200;
                }
                return {
                  id: item.fieldId,
                  minWidth: width,
                };
              }),
            };

            blockData.fields = blockData.fields.filter((el: any) => {
              if (["keeta"].includes(evt.channel)) {
                return (
                  el.fieldId != "mapCategoryName" &&
                  !["skuId", "trdSkuId"].includes(el.fieldId)
                );
              } else {
                return el.fieldId != "mapCategoryName";
              }
            });
          }
          setTableBlockData(blockData);
        }
      })
      .catch(() => {
        setLoading(false);
      });
  };

  const setTableNoData = () => {
    setMenuStatus("");
    tableRef.current?.setTableData([]);
    setNoBindCount("0");
    tableRef.current?.setPagination({
      current: 1,
      total: 0,
      pageSize: 10,
    });
  };

  const fetchData = (info?: any) => {
    setLoading(true);
    getMapdata(
      queryRef.current,
      (res: any) => {
        const { code, list, page, notBindCount } = res;
        setLoading(false);
        setResCode(code);
        tableDataRef.current = list;
        tableRef.current?.setTableData(tableDataRef.current);
        if (notBindCount) {
          setNoBindCount(notBindCount || "0");
        }

        tableRef.current?.setPagination(page);
        setTotal(page.total);
      },
      (code: any) => {
        setLoading(false);
        setResCode(code);
        setTableNoData();
      }
    );

    if (situationsCheck(queryRef.current?.channel, "inSide", [], ["keeta"])) {
      setNoBindLoad(true);
      trdItemQuery({
        channelShopId: queryRef.current.trd.channelShopId,
        isMapped: false,
        page: {
          pageNo: 1,
          pageSize: 10000000,
        },
      }).then((res: any) => {
        setNoBindLoad(false);
        const { code, data } = res;
        if (code === "000") {
          setNoBindCount(data?.page?.total || "0");
        }
      });
    }
  };

  // 未绑定的三方平台商品
  // 批量解绑
  const handleBatchItems = (idArr: any) => {
    if (!idArr || idArr.length == 0) {
      return;
    }
    setUnBindLoading(true);
    bindAndUnbind(
      authInfo.id,
      authInfo.selectedMenuId,
      idArr,
      false,
      (res: any) => {
        setUnBindLoading(false);
        if (res.code == "000") {
          message.success(
            t("receipt_template.opera_success", { ns: "Restaurant" })
          );
          selectRowsRef.current = [];
          setSelectedRowKeys([]);
          fetchData();
          cleanSelect();
        }
      }
    );
  };

  useEffect(() => {
    if (!isShop) {
      // setIsRender(true);
      queryShopListByEmployeeId({
        corporationId: userInfo?.corporationId,
        employeeCode: userInfo?.employeeCode,
        organizationId: userInfo?.orgId,
        orgTypeList: [7, 1],
      })
        .then((res) => {
          const list =
            res.data?.map((row: IKVProps) => {
              return {
                ...row,
                name: row.organizationName,
                dataId: row.organizationId,
                type: row.orgType,
              };
            }) || [];
          const organizationIdObj: any = {};
          // 门店左树，只展示品牌和门店，并且品牌下有所属门店
          const data = list.filter((item: any) => {
            if (item.orgType === 1) {
              organizationIdObj[item.organizationId] = true;
            }
            return [1, 7].includes(item.orgType);
          });
          const hasBrandTreeData: any[] = parseFlatDataToTreeData(
            data,
            "dataId"
          ).filter((item: any) => {
            if (item.type !== 7) {
              item.disabled = true; // 非门店不可选中
            }
            return item.children?.length;
          });
          // 筛选出无品牌的门店，parentId=>organizationId没有的那种
          const noBrandStores = data.filter((item: any) => {
            item.children = [];
            return !organizationIdObj[item.parentId] && item.orgType === 7;
          });
          const treeData: any[] = [].concat(
            noBrandStores,
            hasBrandTreeData as []
          );
          const offsetHeight = pageContainerRef.current
            ? pageContainerRef.current?.getContentHeight() - 78 - 55
            : 0;
          setoffsetHeight(offsetHeight);

          let selectKeys: any = "";
          if (treeData && treeData.length > 0) {
            if (treeData[0].orgType == 7 && treeData[0].dataId) {
              selectKeys = treeData[0].dataId;
            }
            if (treeData[0].children && treeData[0].children.length > 0) {
              if (
                treeData[0].children[0].orgType == 7 &&
                treeData[0].children[0].dataId
              ) {
                selectKeys = treeData[0].children[0].dataId;
                shopIdref.current.shopId = treeData[0].children[0].businessId;
              }
            }

            let takouttreeRows: any = sessionStorage.getItem("takouttreeRows");
            if (takouttreeRows) {
              takouttreeRows = JSON.parse(takouttreeRows);
              let isHaveKey: boolean = false;
              const isHavelist = (data: any) => {
                for (let i = 0; i < data.children.length; i++) {
                  const el = data.children[i];
                  if (el.dataId == takouttreeRows.dataId) {
                    isHaveKey = true;
                    return;
                  } else {
                    if (el.children) {
                      isHavelist(el);
                    }
                  }
                }
              };

              isHavelist({
                dataId: "",
                name: "",
                children: treeData || [],
              });
              if (isHaveKey) {
                selectKeys = takouttreeRows.dataId;
                setExpendtreeKeys([takouttreeRows.parentId]);
                shopIdref.current.shopId = takouttreeRows.businessId;
              } else {
                sessionStorage.removeItem("takouttreeRows");
              }
            }
          }

          setSelectedtreeKeys([selectKeys]);
          console.log("deeeeeeee", treeData);
          setTreeConfig({
            data: treeData || [],
          });
        })
        .catch((err) => {
          //
        });
    }
  }, []);

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
    if (resCode == "20010") {
      return (
        <>
          <div className="text-center">
            <div className="pt-[20px]">
              {t("product.noBindTxt", { ns: "Takeaway" })}
            </div>
            <div className="pt-[20px]">
              <Button
                type="primary"
                onClick={() => {
                  dispatchNavigate("/takeaway-store-binding");
                }}
              >
                {t("instant.GoBind", { ns: "Takeaway" })}
              </Button>
            </div>
          </div>
        </>
      );
    }
    if (resCode === "90000") {
      return (
        <>
          <div className="text-center">
            <div className="pt-[20px]">
              {t("product.menuIsDel", { ns: "Takeaway" })}
            </div>
            <div className="pt-[20px]">
              <Button
                type="primary"
                onClick={() => {
                  menuModalRef.current?.open({
                    ...queryRef.current,
                  });
                }}
              >
                {t("product.againSelBinMenu", { ns: "Takeaway" })}
              </Button>
            </div>
          </div>
        </>
      );
    }
    if (resCode == "20009") {
      return (
        <div className="text-center">
          <div className="pt-[20px]">
            {t("product.storeNoBindMenu", { ns: "Takeaway" })}
          </div>
          <div className="pt-[20px]">
            <Button
              type="primary"
              onClick={() => {
                menuModalRef.current?.open({
                  ...queryRef.current,
                });
              }}
            >
              {t("product.selBinMenu", { ns: "Takeaway" })}
            </Button>
          </div>
        </div>
      );
    }
    return null;
  }, [authInfo, menuInfo, menuStatus, resCode]);

  const items: any[] = [
    {
      key: "1",
      label: (
        <div
          onClick={() => {
            pushModalRef.current?.open();
          }}
        >
          {t("product.btnPublishOther", { ns: "Takeaway" })}
        </div>
      ),
    },
    {
      key: "2",
      label: (
        <div
          onClick={() => {
            const menuItem = queryRef.current.treeRow || {};
            let url = `/takeaway-product-mapping-record?label=${typeObj.label}&type=${typeObj.key}&shopId=${queryRef.current?.shopId}`;
            if (userInfo?.orgType === "0") {
              url += `&targetOrgId=${menuItem.organizationId}&targetOrgType=${menuItem.orgType}`;
            }
            dispatchNavigate(url);
          }}
        >
          {t("product.btnPublishRecord", { ns: "Takeaway" })}
        </div>
      ),
    },
  ];

  // 清空批量选中
  const cleanSelect = () => {
    setSelectedRowKeys([]);
    selectRowsRef.current = [];
  };

  // 上下架
  const batchSetMenuStatus = (
    itemIds: string[],
    enable?: boolean,
    itemPaths?: string[],
    skuidList?: string[]
  ) => {
    const _skuidList = _.cloneDeep(skuidList);
    if (timeOutRef.current) {
      clearTimeout(timeOutRef.current);
      setOperaLoading(false);
    }
    setLoading(true);
    if (
      ["urbanPiper", "grab", "foodPanda", "fantuan", "deliveroo"].indexOf(
        queryRef.current?.channel
      ) > -1
    ) {
      // up的上下架操作
      setOperaLoading(true);
      const getStatus = (referenceId: string) => {
        queryOptionResult({ referenceId })
          .then((res: any) => {
            if (res.code == "000") {
              if (res.data.success == "1" || res.data.success == "2") {
                message.success(
                  t("receipt_template.opera_success", { ns: "Restaurant" })
                );
                fetchData();
                cleanSelect();
                setOperaLoading(false);
                setLoading(false);
                if (timeOutRef.current) {
                  clearTimeout(timeOutRef.current);
                }
              } else {
                timeOutRef.current = setTimeout(() => {
                  getStatus(referenceId);
                }, 3000);
              }
            }
          })
          .catch(() => {
            setLoading(false);
            setOperaLoading(false);
          });
      };

      upBatchItemStatus({
        enable: enable === true ? true : false,
        itemIds: itemIds || [],
        itemPaths: itemPaths || [],
        menuId: menuInfo.menuId,
        shopId: queryRef.current.shopId,
        platform: queryRef.current.platform,
        skuItemIds: _skuidList,
      })
        .then((res) => {
          const { code, data } = res;
          if (code === "000") {
            if (
              ["grab", "foodPanda", "fantuan", "deliveroo", "keeta"].includes(
                queryRef.current?.channel
              )
            ) {
              message.success(
                t("receipt_template.opera_success", { ns: "Restaurant" })
              );
              fetchData();
              cleanSelect();
              setLoading(false);
              setOperaLoading(false);
            } else {
              getStatus(data);
            }
          }
        })
        .catch((err) => {
          setLoading(false);
          setOperaLoading(false);
        });
    } else if (queryRef.current?.channel === "hungryPanda") {
      setOperaLoading(true);
      batchItemStatus({
        itemStatuses: itemIds.map((o) => {
          return {
            itemId: o,
            status: enable === true ? "on_shelf" : "off_shelf",
          };
        }),
        shopId: queryRef.current.shopId,
        platform: queryRef.current.platform,
      })
        .then((res) => {
          setLoading(false);
          setOperaLoading(false);
          const { code, data } = res;
          if (code === "000") {
            message.success(
              t("receipt_template.opera_success", { ns: "Restaurant" })
            );
            fetchData();
            cleanSelect();
          }
        })
        .catch((err) => {
          setLoading(false);
          setOperaLoading(false);
        });
    } else {
      const on: any = [];
      const off: any = [];
      selectRowsRef.current.forEach((el: any) => {
        if (el.trdItems && el.trdItems.length > 0) {
          el.trdItems.forEach((item: any) => {
            const data = {
              trdItemId: item.trdItemId,
              trdUnitId: item.trdUnitId,
            };
            if (
              enable &&
              !on.map((o: any) => o.trdItemId).includes(data.trdItemId)
            ) {
              on.push(data);
            }
            if (
              !enable &&
              !off.map((o: any) => o.trdItemId).includes(data.trdItemId)
            ) {
              off.push(data);
            }
          });
        }
      });

      setOperaLoading(true);
      unmountChange(authInfo.id, on, off);
    }
  };

  // 国内上下架
  const unmountChange = (channelShopId: string, on?: any, off?: any) => {
    itemSwitch({
      channelShopId,
      on,
      off,
    })
      .then((res: any) => {
        setLoading(false);
        setOperaLoading(false);
        if (res.code === "000") {
          message.success(
            t("receipt_template.opera_success", { ns: "Restaurant" })
          );
          fetchData();
          cleanSelect();
        }
      })
      .catch(() => {
        setLoading(false);
        setOperaLoading(false);
      });
  };

  useEffect(() => {
    tableRef.current?.formMethods?.setFieldDataSource("itemStatus", [
      {
        label: t("product.statusOnSelf", { ns: "Takeaway" }),
        value: "on_shelf",
      },
      {
        label: t("product.statusOffSelf", { ns: "Takeaway" }),
        value: "off_shelf",
      },
    ]);
  }, [type]);

  // 按钮
  const extraButton = (record: any) => {
    const btnsList: any = [];
    if (situationsCheck(queryRef.current?.channel, "inSide")) {
      if (record?.trdItemId && record?.trdItemId !== "-") {
        btnsList.push(
          <Button
            size="small"
            type="link"
            onClick={() => {
              if (!record?.itemId) {
                message.warning(t("instant.noItemID", { ns: "Takeaway" }));
                return;
              }
              menuItemModalRef.current?.open({
                record,
                queryData: queryRef.current,
                type: "checkbox",
                total,
              });
            }}
          >
            {t("takeaway.btnChangeBind", { ns: "Takeaway" })}
            {/* 换绑 */}
          </Button>
        );
        btnsList.push(
          <Button
            size="small"
            type="link"
            loading={unBindLoading}
            onClick={() => {
              confimModelref.current.open({
                title: "",
                icon: "",
                width: 500,
                buttonText: "",
                buttonList: [
                  <Button
                    type="default"
                    onClick={() => {
                      confimModelref.current.destroy();
                    }}
                  >
                    {t("mainBranch.cancelInfo", { ns: "Financial" })}
                  </Button>,
                  <Button
                    type="primary"
                    onClick={() => {
                      const list =
                        record.trdItems &&
                        record.trdItems.map((el: any) => {
                          return {
                            trdItemId: el.trdItemId,
                            trdUnitId: el.trdUnitId,
                            itemId: null,
                            itemName: record.itemName,
                            unitId: record.unitId,
                            unitName: record.unitName,
                          };
                        });

                      handleBatchItems(list);
                      confimModelref.current.destroy();
                    }}
                  >
                    {t("takeaway.btnUnbind", { ns: "Takeaway" })}
                    {/* 解绑 */}
                  </Button>,
                ],
                // textTitle: t("common.tips", { ns: "Common" }),
                text: t("takeaway.confirmTxtUnBind", { ns: "Takeaway" }),
              });
            }}
          >
            {t("takeaway.btnUnbind", { ns: "Takeaway" })}
            {/* 解绑 */}
          </Button>
        );
      } else {
        btnsList.push(
          <Button
            size="small"
            type="link"
            onClick={() => {
              if (!record?.itemId) {
                message.warning("没有商品itemId");
                return;
              }
              menuItemModalRef.current?.open({
                record,
                queryData: queryRef.current,
                type: "checkbox",
                total,
              });
            }}
          >
            {/* 绑定 */}
            {t("product.btnBind", { ns: "Takeaway" })}
          </Button>
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
      >
        <Space>
          {["chowly", "grab"].indexOf(typeObj.channel) < 0 ? (
            <Space>
              <Button
                loading={operaLoading}
                onClick={() => {
                  if (selectRowsRef.current.length === 0) {
                    message.warning(
                      t("takeaway.txtPleaseSelPro", { ns: "Takeaway" })
                    );
                    return;
                  }
                  const text = "";
                  const textTitle = `${t("Takeaway.confirmShelf", {
                    ns: "Takeaway",
                  })}？`;

                  confimModelref.current.open({
                    title: "",
                    icon: "",
                    width: 500,
                    buttonText: "",
                    buttonList: [
                      <Button
                        type="default"
                        onClick={() => {
                          confimModelref.current.destroy();
                        }}
                      >
                        {t("mainBranch.cancelInfo", { ns: "Financial" })}
                      </Button>,
                      <Button
                        type="primary"
                        onClick={() => {
                          batchSetMenuStatus(
                            selectRowsRef.current.map((o) => {
                              if (
                                situationsCheck(
                                  queryRef.current?.channel,
                                  "inSide"
                                )
                              ) {
                                return o.id || "";
                              }
                              return o.itemId;
                            }),
                            true,
                            selectRowsRef.current.map((o) => {
                              if (
                                ["urbanPiper", "grab"].indexOf(
                                  queryRef.current?.channel
                                ) > -1
                              ) {
                                return o.itemPath || "";
                              }
                              return null;
                            }),
                            selectRowsRef.current.map((o) => {
                              if (o.itemType == "Item" && o.skuId) {
                                return o.skuId;
                              }
                              return null;
                            })
                          );
                          confimModelref.current.destroy();
                        }}
                      >
                        {t("common.confirm", { ns: "Common" })}
                      </Button>,
                    ],
                    textTitle: textTitle,
                    text: text,
                  });
                }}
              >
                {/* 批量上架 */}
                {t("product.btnBatchUp", { ns: "Takeaway" })}
              </Button>
              <Button
                loading={operaLoading}
                onClick={() => {
                  if (selectRowsRef.current.length === 0) {
                    message.warning(
                      t("takeaway.txtPleaseSelPro", { ns: "Takeaway" })
                    );
                    return;
                  }
                  const text =
                    ["meituanMerchant", "meituan"].indexOf(
                      queryRef.current?.channel
                    ) > -1
                      ? t("instant.associatedMeituansynchronized", {
                          ns: "Takeaway",
                        })
                      : "";
                  const textTitle =
                    t("Takeaway.confirmUnshelf", { ns: "Takeaway" }) + "?";

                  confimModelref.current.open({
                    title: "",
                    icon: "",
                    width: 500,
                    buttonText: "",
                    buttonList: [
                      <Button
                        type="default"
                        onClick={() => {
                          confimModelref.current.destroy();
                        }}
                      >
                        {t("mainBranch.cancelInfo", { ns: "Financial" })}
                      </Button>,
                      <Button
                        type="primary"
                        onClick={() => {
                          batchSetMenuStatus(
                            selectRowsRef.current.map((o) => {
                              if (
                                situationsCheck(
                                  queryRef.current?.channel,
                                  "inSide"
                                )
                              ) {
                                return o.id || "";
                              }
                              return o.itemId;
                            }),
                            false,
                            selectRowsRef.current.map((o) => {
                              if (
                                ["urbanPiper", "grab"].indexOf(
                                  queryRef.current?.channel
                                ) > -1
                              ) {
                                return o.itemPath || "";
                              }
                              return null;
                            }),
                            selectRowsRef.current.map((o) => {
                              if (o.itemType == "Item" && o.skuId) {
                                return o.skuId;
                              }
                              return null;
                            })
                          );
                          confimModelref.current.destroy();
                        }}
                      >
                        {t("common.confirm", { ns: "Common" })}
                      </Button>,
                    ],
                    textTitle: textTitle,
                    text: text,
                  });
                }}
              >
                {/* 批量下架 */}
                {t("product.btnBatchDown", { ns: "Takeaway" })}
              </Button>
            </Space>
          ) : (
            ""
          )}

          {situationsCheck(queryRef.current?.channel, "inSide", ["candao"]) && (
            <Button
              loading={unBindLoading}
              onClick={() => {
                if (selectRowsRef.current.length === 0) {
                  message.warning(
                    t("takeaway.txtPleaseSelPro", {
                      ns: "Takeaway",
                    })
                  );
                  return;
                }

                confimModelref.current.open({
                  title: "",
                  icon: "",
                  width: 500,
                  buttonText: "",
                  buttonList: [
                    <Button
                      type="default"
                      onClick={() => {
                        confimModelref.current.destroy();
                      }}
                    >
                      {t("mainBranch.cancelInfo", { ns: "Financial" })}
                    </Button>,
                    <Button
                      type="primary"
                      onClick={() => {
                        const list: any = [];
                        selectRowsRef.current.forEach((record: any) => {
                          record.trdItems.forEach((el: any) => {
                            list.push({
                              trdItemId: el.trdItemId,
                              trdUnitId: el.trdUnitId,
                              itemId: null,
                              itemName: record.itemName,
                              unitId: record.unitId,
                              unitName: record.unitName,
                            });
                          });
                        });
                        handleBatchItems(list);
                        confimModelref.current.destroy();
                      }}
                    >
                      {t("takeaway.btnBatchUnbind", { ns: "Takeaway" })}
                    </Button>,
                  ],
                  // textTitle: t("common.tips", { ns: "Common" }),
                  text: t("takeaway.confirmTxtUnBind", { ns: "Takeaway" }),
                });
              }}
            >
              {/* 批量解绑 */}
              {t("takeaway.btnBatchUnbind", { ns: "Takeaway" })}
            </Button>
          )}
        </Space>
        <Space style={{ marginLeft: "10px" }}>
          <Button
            danger
            loading={noBindLoad}
            onClick={() => {
              dispatchNavigate(`/takeaway-product-mapping-syncunbind`, {
                state: {
                  shopId: queryRef.current.shopId,
                  platform: queryRef.current.platform,
                  channel: queryRef.current.channel,
                  menuId: menuInfo.menuId,
                  name: typeObj.label,
                  channelShopId: authInfo.id,
                },
              });
            }}
          >
            {/* 未绑定的三方平台商品 */}
            {t("product.btnNoPro", { ns: "Takeaway" })}（{notBindCount}）
          </Button>

          <Button
            type="primary"
            ghost
            onClick={() => {
              menuModalRef.current?.open();
            }}
          >
            {/* 切换外卖菜单 */}
            {t("product.btnChangeMenu", { ns: "Takeaway" })}
          </Button>
          {situationsCheck(queryRef.current.channel, "inSide") && (
            <>
              <ThirdItemsLoad
                type="0"
                channelShopId={authInfo.id}
                onChange={() => {
                  fetchData();
                }}
              />
              {["0", "1"].includes(userInfo?.orgType) && (
                //   {/* 复制绑定关系至其他门店 */}
                <Button
                  type="primary"
                  ghost
                  onClick={() => {
                    copyShopref.current?.open({
                      channelShopId: authInfo.id,
                      platform: queryRef.current.platform,
                    });
                  }}
                >
                  {t("productMap.copybindingrelationshiptoother", {
                    ns: "Takeaway",
                  })}
                </Button>
              )}

              <Button
                type="primary"
                onClick={() => {
                  batchModalRef.current?.open({
                    query: {
                      shopId: queryRef.current.shopId || "",
                      platform: queryRef.current.platform || "",
                      trdMenuId: queryRef.current.trdMenuId || "",
                    },
                  });
                }}
              >
                {/* 批量绑定 */}
                {t("takeaway.btnBatchBind", { ns: "Takeaway" })}
              </Button>
            </>
          )}
          {situationsCheck(queryRef.current.channel, "outSide") && (
            <Dropdown menu={{ items }} placement="bottom">
              <Button type="primary">
                {t("item.publish", { ns: "Item" })}
                <DownOutlined />
              </Button>
            </Dropdown>
          )}
          {["keeta"].includes(queryRef.current.channel) && (
            <Button
              onClick={() => {
                pushModalRef.current?.open();
              }}
              type="primary"
            >
              {t("product.btnPublishOther", { ns: "Takeaway" })}
            </Button>
          )}
        </Space>
      </div>
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

  const filterTreeDataFeSearch = useCallback(
    (data: IKVProps[], isChildren = false): IKVProps[] => {
      return data
        ?.map((item) => {
          const isMatch = item?.name
            ?.toLowerCase()
            ?.includes?.(treeSearchKeyword?.toLowerCase());

          const children = item.children
            ? filterTreeDataFeSearch(item?.children, true)
            : [];

          if (isMatch || (children && children.length > 0)) {
            return {
              ...item,
              children: children,
            };
          }
          return null;
        })
        .filter(Boolean) as IKVProps[];
    },
    [treeSearchKeyword]
  );

  return (
    <PageContainer
      title={titletext}
      ref={pageContainerRef}
      titleLeftSlot={
        threeLevelLinkageLanguage ? (
          <div
            style={{
              marginLeft: "40px",
              width: `${pureWidth - 100 - countCharacters(titletext) * 16}px`,
            }}
          >
            <ServiceTabs
              threeLevelLinkageLanguage={threeLevelLinkageLanguage}
              actionCallback={tabChange}
              businessType={"map"}
              onNodata={() => {
                setResCode("20090");
              }}
            />
          </div>
        ) : (
          ""
        )
      }
    >
      <div style={{ height: "100%" }}>
        <Spin spinning={loading} style={{ height: "100%" }}>
          {renderCompos ? (
            <ComposeTreeTable
              className={!isShowSearch ? styles.productmapclass : ""}
              memoryAction={false}
              key={renderKey}
              ref={tableRef}
              layout="Horizontal"
              treeConfig={
                ["0", "1"].includes(userInfo?.orgType)
                  ? {
                      data: filterTreeDataFeSearch(treeConfig?.data || []),
                      selectedKeys: selectedtreeKeys,
                      expandedKeys: expendtreeKeys,
                      extraProps: {
                        fieldNames: {
                          title: "name",
                          key: "dataId",
                        },
                      },
                      searchConfig: {
                        visible: true,
                        placeholder: t("common.search", { ns: "Common" }),
                        callback: (e: any) => {
                          setTreeSearchKeyword(e);
                        },
                      },
                    }
                  : undefined
              }
              formConfig={{
                blockData: formBlockData,
                showReset: true,
                showSearch: true,
                bottomSlot: !noData && resCode && bottomContent(),
              }}
              tableConfig={{
                blockData: tableBlockData,
                columns: tableColumns(),
                rowKey: "leftnid",
                showOperationColumn: true,
                pureWidth: pureWidth - (!isShop ? 240 + 45 : 30),
                showIndexColumn: true,
                extraProps: {
                  locale: {
                    emptyText: noData,
                  },
                  rowSelection: {
                    selectedRowKeys: selectedRowKeys,
                    type: "checkbox",
                    getCheckboxProps: (record: any) => {
                      return {
                        disabled:
                          (record.bindStatusValue &&
                            record.bindStatusValue == 0) ||
                          (!record?.trdSkuId && !record.trdItemName),
                      };
                    },
                    onChange: (
                      selectedRowKeys: string[],
                      selectedRows: any[]
                    ) => {
                      console.log(
                        "selectedRowKeys",
                        selectedRowKeys,
                        selectedRows
                      );
                      setSelectedRowKeys(selectedRowKeys);
                      if (selectedRows && selectedRows.length > 0) {
                        selectRowsRef.current = selectedRows;
                      } else {
                        selectRowsRef.current = [];
                        setSelectedRowKeys([]);
                      }
                    },
                  },
                },
                operationColumnProps: {
                  outsideBtnCount: 2,
                  width: situationsCheck(queryRef.current?.channel, "inSide")
                    ? 120
                    : 88,
                  extraButtonRender: (record: any) => {
                    return extraButton(record);
                  },
                },
              }}
              actionCallback={actionCallback}
            />
          ) : (
            ""
          )}
        </Spin>

        {typeObj && menuInfo ? (
          <TakeawayMenus
            typeObj={typeObj}
            menuInfo={menuInfo}
            menuTree={menuTree}
            ref={menuModalRef}
            title={t("product.selBinMenu", { ns: "Takeaway" })}
            onCloseTakeaway={(params: any) => {
              batchModalRef.current?.close();
              if (params && params.isPiliang) {
                getShopBindStatus(typeObj, null, params.isPiliang);
              }
            }}
            onChange={(rows: any) => {
              if (Array.isArray(rows) && rows.length > 0) {
                changeOperateShop({
                  id: menuInfo.id,
                  selectedMenuId: rows[0]?.menuId,
                  selectedMenuName: rows[0]?.menuName,
                })
                  .then((res) => {
                    const { code, data } = res;
                    if (code === "000") {
                      // message.success("切换菜单成功");
                      message.success(
                        t("general.menuSwitchSuccess", { ns: "Financial" })
                      );
                      getShopBindStatus();
                    }
                  })
                  .catch((err) => {
                    //
                  });
              }
            }}
          />
        ) : (
          ""
        )}

        <MenuItems
          title={t("takeaway.titleSelectTrdPro", { ns: "Takeaway" })}
          ref={menuItemModalRef}
          query={queryParams}
          typeObj={typeObj}
          menuInfo={menuInfo}
          itemTypeOptions={itemTypeOptions}
          total={total}
          channelShopId={authInfo.id}
          onChange={() => {
            fetchData();
          }}
        />

        {typeObj && JSON.stringify(typeObj) != "{}" ? (
          <SyncDeleteModal
            ref={syncDeleteModalRef}
            menuInfo={menuInfo}
            tableBlock={tableBlockData}
            typeObj={typeObj}
            title={`${typeObj.label} - ${t("product.btnNoPro", {
              ns: "Takeaway",
            })}`}
          />
        ) : (
          ""
        )}

        <BatchBindModal
          ref={batchModalRef}
          typeObj={typeObj}
          query={queryParams}
          menuInfo={menuInfo}
          total={total}
          channelShopId={authInfo.id}
          onOpenchangeMenu={() => {
            menuModalRef.current?.open({
              ...queryRef.current,
              isPiliang: true,
            });
          }}
          onChange={() => {
            fetchData();
          }}
          title={t("takeaway.titleTrdBindType", {
            ns: "Takeaway",
            n: typeObj.label,
          })}
        />
        <PushThirdModal
          ref={pushModalRef}
          menuInfo={menuInfo}
          query={queryParams}
          onChange={() => {
            fetchData();
          }}
          title={`${t("product.btnPublishOther", { ns: "Takeaway" })}[${
            typeObj.label
          }]`}
        />

        <ConfimModel ref={confimModelref} />

        <CopyShopModal ref={copyShopref} />
      </div>
    </PageContainer>
  );
};

export default View;
