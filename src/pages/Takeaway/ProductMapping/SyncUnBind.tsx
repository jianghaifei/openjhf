// 外卖菜单弹层
import { Button, Modal, Tooltip, Image, Switch, Space, message } from "antd";
import { useMemo, useRef, useState, forwardRef, useEffect } from "react";
import { useLoaderData, useSearchParams, useLocation } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { ITable } from "@src/Components/Table/ITable";
import PageContainer from "@src/Components/Layouts/PageContainer";
import useCustomNavigate from "@src/Hooks/useCustomNavigate";
import { ArrowLeftOutlined } from "@ant-design/icons";

import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import {
  queryUnBindItems,
  ubQueryUnBindItems,
  batchItemStatus,
  upBatchItemStatus,
} from "@src/Api/Takeaway/StoreAndItems";

import {
  categoryMapping,
  trdItemQuery,
  itemSwitch,
} from "@src/Api/Takeaway/takeoutDelivery";
import { IKVProps } from "@restosuite/field-core";
import _ from "lodash";
import { getCurrencySymbol } from "@src/Utils/CommonUtils";
import BatchThirdClass from "./Components/BatchThirdClass";
import DefaultThirdClass from "./Components/DefaultThirdClass";
import { getCategory } from "@src/Api/Common/Rest/SelectDataSource";
import ThirdItemsLoad from "./Components/ThirdItemsLoad";
import { situationsCheck } from "../Components/IHelper";
import styles from "./Components/index.module.less";
export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const location = useLocation();
  const { shopId, platform, channel, menuId, name, channelShopId } =
    location.state || {};
  const { dispatchNavigate, goback } = useCustomNavigate();
  const pageContainerRef = useRef<any>(null);
  // const [searchParams] = useSearchParams();
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const { pageUtils } = useLoaderData() as any;
  const [loading, setLoading] = useState<boolean>(false);
  const [pureWidth, setPureWidth] = useState<number>(0);
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const actionParamsRef = useRef<any>({});
  const BatchThirdClassRef = useRef<any>(null);
  const DefaultThirdClassRef = useRef<any>(null);
  const [tableBlock, setTableBlock] = useState<any>(null);
  const [selectedRowKeys, setSelectedRowKeys] = useState<any>([]);
  const [selectedRow, setSelectedRow] = useState<any>([]);
  const [dimensionaRow, setDimensionaRow] = useState<any[]>([]);
  const [categoryList, setCategoryList] = useState([]);
  const [categoryInfo, setCategoryInfo] = useState({
    defaultId: "",
    defaultName: "",
  });
  const [synchronization, setSynchronization] = useState(true);
  const [dataList, setDataList] = useState([]);
  // 获取默认分类
  const getdefaultClass = () => {
    categoryMapping({
      channelShopId: channelShopId,
      menuId: menuId,
    }).then((res: any) => {
      console.log(";;", res);
      const { data } = res;
      setCategoryInfo({
        defaultId: data.defaultId,
        defaultName:
          data.defaultName || t("productMap.unconfigured", { ns: "Takeaway" }),
      });
    });
  };
  // 获取商品分类
  useEffect(() => {
    if (situationsCheck(channel as string, "inSide", [], [])) {
      tableRef.current?.formMethods?.setFieldShowHide("mapCategoryName", true);
      getCategory().then((res: any) => {
        const _res = res.map((el: any) => {
          el.disabled = true;
          return el;
        });
        const option = _.cloneDeep(_res);
        option.unshift({
          label: t("productMap.unconfigured", { ns: "Takeaway" }),
          value: "#",
        });
        setCategoryList(_res);
        tableRef.current?.formMethods?.setFieldDataSource(
          "mapCategoryName",
          option
        );
      });
      getdefaultClass();
    } else {
      tableRef.current?.formMethods?.setFieldShowHide("mapCategoryName", false);
    }
  }, [open]);
  useEffect(() => {
    // 获取 blockData
    let blockData = pageUtils.getBlockData("TableList");
    if (situationsCheck(channel as string, "inSide", [], [])) {
      blockData = pageUtils.getBlockData("ElemeTableList");
    }
    if (blockData?.fields && blockData.fields.length > 0) {
      blockData.tableConfig = {
        type: "table",
        operationColumnConfig: {},
        columnConfig: blockData?.fields.map((item: any) => {
          const _field = {
            id: item.fieldId,
            minWidth: 150,
          };
          if (["trdSkuId"].includes(item.fieldId)) {
            _field.minWidth = 200;
          }
          return _field;
        }),
      };
    }
    setTableBlock(blockData);
  }, [pageUtils, channel]);

  const newBlockData = useMemo(() => {
    if (!tableBlock?.fields) {
      return {};
    }
    const bindBlockData: any = pageUtils.getBlockData("noBindTableList");
    const noBindsynch: any = pageUtils.getBlockData("noBindsynch");
    const newBlock = _.cloneDeep(tableBlock);

    // 为bindStatus手动设置下宽度，适配横向滚动条
    newBlock.tableConfig.columnConfig.push({
      id: "bindStatus",
      minWidth: 150,
    });

    if (situationsCheck(channel as string, "inSide", [], [])) {
      newBlock.fields = newBlock.fields.slice(7, newBlock.fields.length);
    } else {
      newBlock.fields = newBlock.fields.slice(8, newBlock.fields.length);
    }

    if (situationsCheck(channel as string, "inSide", [], [])) {
      newBlock.fields = [...newBlock.fields];
    } else {
      newBlock.fields = [...newBlock.fields];
    }
    // 删除餐道的上下架
    if (["meituan", "candao", "chowly"].indexOf(channel as string) > -1) {
      newBlock.fields = newBlock.fields.filter(
        (el: any) => el.fieldId != "itemStatus"
      );
      newBlock.tableConfig.columnConfig =
        newBlock.tableConfig.columnConfig.filter(
          (el: any) => el.id != "itemStatus"
        );
    }
    setOpen(true);
    return newBlock;
  }, [tableBlock]);

  const formBlockData = useMemo(() => {
    const blockData = pageUtils.getBlockData("QueryFormSync");
    const customField = pageUtils.getBlockData(
      "QueryFormCustomFieldSyncDeleteModal"
    );
    let fields = customField?.fields;
    if (situationsCheck(channel as string, "inSide") && fields) {
      fields = fields.filter((o: any) => o.fieldId != "trdSkuId");
    }
    const _cloneData = _.cloneDeep(blockData) as any;
    if (blockData?.fields) {
      blockData.fields.unshift({
        fieldType: "CustomFieldComponent",
        title: "",
        fieldId: "combinedFields",
        languageData: {},
        fieldProps: {
          customFieldComponent: "CombinedTypeInput",
        },
        componentProps: {
          customFields: fields,
          allowClear: false,
        },
      });
    }
    return _cloneData;
  }, [tableBlock]);

  const syncStatusOptions = useMemo(() => {
    const blockData: any = newBlockData || {};
    const options = blockData.fields?.find(
      (item: any) => item.fieldId === "syncStatus"
    )?.data?.dataSource;
    return options;
  }, [newBlockData]);

  const itemTypeOptions = useMemo(() => {
    const blockData: any = tableBlock || {};
    const options = blockData.fields?.find(
      (item: any) => item.fieldId === "itemType"
    )?.data?.dataSource;
    return options || [];
  }, [tableBlock]);

  // 国内上下架
  const unmountChange = (channelShopId: string, on?: any, off?: any) => {
    itemSwitch({
      channelShopId,
      on,
      off,
    })
      .then((res: any) => {
        setLoading(false);
        if (res.code === "000") {
          message.success(
            t("receipt_template.opera_success", { ns: "Restaurant" })
          );
          fetchData();
        }
      })
      .catch(() => {
        setLoading(false);
      });
  };

  // 批量上下架
  const batchSetMenuStatus = (
    itemIds: string[],
    enable?: boolean,
    trdSkuId?: string,
    skuidList?: string[],
    trdUnitId?: any
  ) => {
    const _skuidList = _.cloneDeep(skuidList);
    setLoading(true);
    if (
      ["urbanPiper", "grab", "foodPanda", "fantuan", "deliveroo"].indexOf(
        channel as string
      ) > -1
    ) {
      // up的上下架操作
      upBatchItemStatus({
        enable: enable === true ? true : false,
        itemIds: itemIds || [],
        menuId: menuId as string,
        shopId: shopId,
        platform: platform,
        skuItemIds: _skuidList,
      })
        .then((res: any) => {
          setLoading(false);
          const { code, data } = res;
          if (code === "000") {
            message.success(
              t("receipt_template.opera_success", { ns: "Restaurant" })
            );
            fetchData();
          }
        })
        .catch((err: any) => {
          setLoading(false);
        });
    } else if ((channel as string) === "hungryPanda") {
      batchItemStatus({
        itemStatuses: itemIds.map((o) => {
          return {
            itemId: o,
            status: enable === true ? "on_shelf" : "off_shelf",
          };
        }),
        shopId: shopId,
        platform: platform,
      })
        .then((res: any) => {
          setLoading(false);
          const { code, data } = res;
          if (code === "000") {
            message.success(
              t("receipt_template.opera_success", { ns: "Restaurant" })
            );
            fetchData();
          }
        })
        .catch((err: any) => {
          setLoading(false);
        });
    } else {
      const on = [];
      const off = [];
      const data = {
        trdItemId: itemIds[0],
        trdUnitId: trdUnitId,
      };
      if (enable === true) {
        on.push(data);
      }

      if (enable !== true) {
        off.push(data);
      }

      unmountChange(channelShopId as string, on, off);
    }
  };

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
      if (getCustomLength(child) < 16) {
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

  const tableColumns: ITable["columns"] = [
    {
      dataIndex: "trdSubMenuName",
      render(value: string, record: any) {
        return <div>{TableCtl(value)}</div>;
      },
    },
    {
      dataIndex: "trdItemName",
      render(value: string, record: any) {
        return <div>{TableCtl(value)}</div>;
      },
    },
    {
      dataIndex: "trdItemImage",
      render(value: string, record: any) {
        return value ? <Image width={30} src={value} /> : "-";
      },
    },
    {
      dataIndex: "itemImage",
      render(value: string, record: any) {
        return value ? <Image width={30} src={value} /> : "-";
      },
    },
    {
      dataIndex: "mapCategoryName",
      render(value: string, record: any) {
        return value ? value : "-";
      },
    },

    {
      dataIndex: "itemType",
      render(value: string, record: any) {
        const label =
          itemTypeOptions.find((child: any) => child.value === value)
            ?.languageData[i18n.language] || value;
        return label;
      },
    },
    {
      dataIndex: "trdItemType",
      render(value: string, record: any) {
        const val = value === "Single" ? "Item" : value;
        const label =
          itemTypeOptions.find((child: any) => child.value === val)
            ?.languageData[i18n.language] || value;
        return label;
      },
    },
    {
      dataIndex: "itemStatus",
      render(value: string, record: any) {
        return [1, 0].includes(record.itemStatus) ||
          [1, 0].includes(record.trdStatus) ? (
          <Space>
            {(record.itemStatus ? record.itemStatus : record.trdStatus) === 1
              ? t("product.statusOnSelf", { ns: "Takeaway" })
              : t("product.statusOffSelf", { ns: "Takeaway" })}
            <Switch
              checked={
                !!(record.itemStatus ? record.itemStatus : record.trdStatus)
              }
              onChange={(evt: any) => {
                Modal.confirm({
                  title: t("common.tips", { ns: "Common" }),
                  content: t("product.confirmOperaNext", { ns: "Takeaway" }),
                  onOk() {
                    if (record.trdItemType == "Item" && record.skuId) {
                      batchSetMenuStatus(
                        [record.trdItemId, record.itemId],
                        evt,
                        record.trdSkuId,
                        [record.skuId],
                        record.trdUnitId
                      );
                    } else {
                      batchSetMenuStatus(
                        [record.trdItemId, record.itemId],
                        evt,
                        record.trdSkuId,
                        [],
                        record.trdUnitId
                      );
                    }
                  },
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

  const fetchData = () => {
    const successRes = (data: any) => {
      const { itemRelations = [] } = data;
      const currencySymbol = getCurrencySymbol();
      try {
        const listData = itemRelations.map((item: any) => {
          const newItem: any = {
            ...item,
            price: item.price ? `${currencySymbol}${item.price}` : "",
            trdPrice: item.trdPrice ? `${currencySymbol}${item.trdPrice}` : "",
          };
          if (situationsCheck(channel as string, "inSide")) {
            // 国内的都是绑定状态，且都应该是未绑定
            newItem.bindStatus = t("product.bindStatusNo", { ns: "Takeaway" }); // 这里写死了，是未绑定，没有从枚举里取
          } else {
            newItem.syncStatus =
              syncStatusOptions?.find(
                (child: any) => child.value === item.syncStatus
              )?.label || "";
          }
          if (item.trdPosItemId && item.trdPosItemId.indexOf("/") > -1) {
            const ids = item.trdPosItemId.split("/");
            newItem.trdItemId = ids[ids.length - 1];
          }
          Object.keys(newItem).forEach((key: string) => {
            let val = newItem[key];
            if (key !== "itemImage" && key !== "trdItemImage") {
              val = newItem[key] || newItem[key] == 0 ? newItem[key] : "-";
            }
            newItem[key] = val;
          });
          // 三方规格名称
          if (newItem.trdUnitName) {
            newItem.trdItemSizeName = newItem.trdUnitName;
          }
          // 三方商品分类
          if (newItem.trdCategoryName) {
            newItem.trdSubMenuName = newItem.trdCategoryName;
          }
          if (newItem.trdSkuId) {
            newItem.nid = newItem.trdItemId + newItem.trdSkuId;
          } else {
            newItem.nid = newItem.trdItemId + newItem.trdUnitId;
          }

          // console.log(90909, newItem);
          return newItem;
        });
        setDataList(listData);

        tableRef.current?.setTableData(listData);
        tableRef.current?.setPagination({
          current: data.page?.pageNo || 1,
          total: data.page?.total,
          pageSize: data.page?.pageSize,
        });
      } catch (e) {
        console.error(e);
      }
    };
    setLoading(true);
    if (
      [
        "urbanPiper",
        "grab",
        "chowly",
        "foodPanda",
        "fantuan",
        "deliveroo",
      ].indexOf(channel as string) > -1
    ) {
      ubQueryUnBindItems(actionParamsRef.current)
        .then((res: any) => {
          setLoading(false);
          const { code, data } = res;
          if (code === "000") {
            successRes(data);
          }
        })
        .catch((e) => {
          setLoading(false);
        });
    } else if (channel === "hungryPanda") {
      queryUnBindItems(actionParamsRef.current)
        .then((res: any) => {
          setLoading(false);
          const { code, data } = res;
          if (code === "000") {
            successRes(data);
          }
        })
        .catch((e) => {
          setLoading(false);
        });
    } else {
      trdItemQuery({
        ...actionParamsRef.current,
        needInfo: true,
        isMapped: false,
      })
        .then((res: any) => {
          setLoading(false);
          const { code, data } = res;
          if (code === "000") {
            data.itemRelations = data.list;
            successRes(data);
          }
        })
        .catch((e) => {
          setLoading(false);
        });
      // elemeQueryPageUnbindItems({
      //   ...actionParamsRef.current,
      //   channel: channel,
      // })
      //   .then((res: any) => {
      //     setLoading(false);
      //     const { code, data } = res;
      //     if (code === "000") {
      //       successRes(data);
      //     }
      //   })
      //   .catch((e) => {
      //     setLoading(false);
      //   });
    }
  };

  // 字段转换
  const filterTo: any = {
    trdItemName: "trdItemName",
    trdItemNameLike: "trdItemNameLike",
  };
  const actionCallback = (
    actionProps: IComposeTreeTableActionCallbackProps
  ) => {
    if (JSON.stringify(actionProps.formData) == "{}") {
      if (situationsCheck(channel as string, "inSide")) {
        setSynchronization(false);
      }
    } else {
      setSynchronization(true);
    }
    // 对组合式筛选项做处理
    if (actionProps.formData?.combinedFields) {
      actionProps.formData[actionProps.formData.combinedFields?.fieldId] =
        actionProps.formData.combinedFields?.value;
      delete actionProps.formData.combinedFields;
    }
    if (actionProps.formData?.trdItemName) {
      actionProps.formData.trdItemNameLike = actionProps.formData?.trdItemName;
    }
    if (actionProps.formData?.mapCategoryName) {
      actionProps.formData.mapCategoryId =
        actionProps.formData?.mapCategoryName == "#"
          ? ""
          : actionProps.formData?.mapCategoryName;
      delete actionProps.formData.mapCategoryName;
    }
    const actionParams: IKVProps = {
      platform: platform,
      shopId: shopId,
      channelShopId: channelShopId,
      channel: channel,
      page: {
        pageNo: actionProps.pageNo,
        pageSize: actionProps.pageSize,
      },
      ...actionProps.formData,
    };
    actionParams.itemFilter = {};
    Object.keys(actionProps.formData as any[]).forEach((key: string) => {
      const keyName = filterTo[key] || key;
      actionParams.itemFilter[keyName] = (actionProps.formData as any)[key];
    });
    actionParamsRef.current = actionParams;
    fetchData();
    setPureWidth(
      pageContainerRef?.current
        ? pageContainerRef?.current?.getContentWidth()
        : 0
    );
  };

  const onSelectChange = (key: any, row: any) => {
    const newSelectedRow: any = _.cloneDeep(selectedRow);
    newSelectedRow[actionParamsRef.current.page.pageNo - 1] = row;
    setSelectedRowKeys(
      newSelectedRow
        .reduce((accumulator: any, currentValue: any) => {
          return accumulator.concat(currentValue);
        }, [])
        .map((el: any) => el.nid)
    );
    setDimensionaRow(
      newSelectedRow.reduce((accumulator: any, currentValue: any) => {
        return accumulator.concat(currentValue);
      }, [])
    );
    setSelectedRow(newSelectedRow);
  };

  const BatchThirdClassonDelete = (el: any) => {
    let newSelectedRow: any = _.cloneDeep(selectedRow);
    newSelectedRow = newSelectedRow.map((o: any) =>
      o.filter((item: any) => item.nid != el.nid)
    );
    const result = newSelectedRow.reduce(
      (accumulator: any, currentValue: any) => {
        return accumulator.concat(currentValue);
      },
      []
    );
    setSelectedRowKeys(result.map((el: any) => el.nid));
    setDimensionaRow(result);
    setSelectedRow(newSelectedRow);
  };

  return (
    <>
      <PageContainer
        title={
          <div>
            <ArrowLeftOutlined
              style={{
                cursor: "pointer",
                marginRight: "5px",
                fontSize: "17px",
              }}
              onClick={() => {
                dispatchNavigate("/takeaway-product-mapping");
              }}
            />
            {name} - {t("product.btnNoPro", { ns: "Takeaway" })}
            {situationsCheck(channel as string, "inSide") ? (
              <ThirdItemsLoad
                type="2"
                channelShopId={channelShopId}
                onChange={() => {
                  fetchData();
                }}
              />
            ) : (
              ""
            )}
          </div>
        }
        ref={pageContainerRef}
      >
        <div>
          {open ? (
            <ComposeTreeTable
              memoryAction={false}
              ref={tableRef}
              formConfig={{
                blockData: formBlockData,
                showReset: true,
                bottomSlot: (
                  <div>
                    {situationsCheck(channel as string, "inSide") ? (
                      <div className="flex justify-between mb-[10px]">
                        <Button
                          type="primary"
                          ghost
                          onClick={() => {
                            if (dimensionaRow && dimensionaRow.length == 0) {
                              return message.warning(
                                t("takeaway.txtPleaseSelPro", {
                                  ns: "Takeaway",
                                })
                              );
                            }
                            BatchThirdClassRef.current.open(location.state);
                          }}
                        >
                          {/* 批量设置商品分类 */}
                          {t("instant.bulkSetCategory", { ns: "Takeaway" })}
                        </Button>
                        <span
                          style={{
                            display: "flex",
                            alignItems: "center",
                          }}
                        >
                          <b style={{ fontWeight: "normal" }}>
                            {t("productMap.defaultProductCategory", {
                              ns: "Takeaway",
                            })}
                            ：
                          </b>
                          <Tooltip title={categoryInfo.defaultName}>
                            <span
                              style={{
                                maxWidth: "300px",
                                overflow: "hidden",
                                textOverflow: "ellipsis",
                                whiteSpace: "nowrap",
                                display: "inline-block",
                              }}
                            >
                              {categoryInfo.defaultName}
                            </span>
                          </Tooltip>
                          <Button
                            type="link"
                            style={{
                              padding: "0 15px 0",
                              margin: "0",
                              height: "auto",
                            }}
                            onClick={() => {
                              DefaultThirdClassRef.current.open(location.state);
                            }}
                          >
                            {/* 设置 */}
                            {t("instant.setting", { ns: "Takeaway" })}
                          </Button>
                        </span>
                      </div>
                    ) : (
                      ""
                    )}
                  </div>
                ),
              }}
              tableConfig={{
                blockData: newBlockData,
                columns: tableColumns,
                rowKey: "nid",
                showOperationColumn: false,
                pureWidth: pureWidth + 400,
                extraProps: {
                  locale: !synchronization
                    ? {
                        emptyText: (
                          <ThirdItemsLoad
                            type="1"
                            channelShopId={channelShopId}
                            onChange={() => {
                              fetchData();
                            }}
                          />
                        ),
                      }
                    : {},
                  loading: loading,
                  rowSelection: {
                    selectedRowKeys: selectedRowKeys,
                    type: "checkbox",
                    getCheckboxProps: (record: any) => {
                      return {
                        disabled:
                          (!record?.trdSkuId && !record.trdItemName) ||
                          (record?.trdSkuId === "-" &&
                            record.trdItemName === "-"),
                      };
                    },
                    onChange: onSelectChange,
                  },
                },
              }}
              actionCallback={actionCallback}
            />
          ) : (
            ""
          )}
        </div>
      </PageContainer>
      <DefaultThirdClass
        ref={DefaultThirdClassRef}
        categoryInfo={categoryInfo}
        categoryList={categoryList}
        state={location.state}
        onChange={() => {
          fetchData();
          getdefaultClass();
        }}
      />
      <BatchThirdClass
        categoryList={categoryList}
        ref={BatchThirdClassRef}
        state={location.state}
        dimensionaRow={dimensionaRow}
        onDelete={BatchThirdClassonDelete}
        onChange={() => {
          fetchData();
          setSelectedRowKeys([]);
          setSelectedRow([]);
          setDimensionaRow([]);
        }}
      />
    </>
  );
});

export default View;
