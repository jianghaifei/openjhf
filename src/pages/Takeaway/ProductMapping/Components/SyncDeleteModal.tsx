// 外卖菜单弹层
import { Button, Modal, Input, Image, Switch, Space, message } from "antd";
import { useMemo, useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useLoaderData } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import { ITable } from "@src/Components/Table/ITable";
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
  elemeQueryPageUnbindItems,
  elemeBatchItemStatus,
} from "@src/Api/Takeaway/StoreAndItems";
import { IKVProps } from "@restosuite/field-core";
import _ from "lodash";
import { getCurrencySymbol } from "@src/Utils/CommonUtils";

const { Search } = Input;
export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const pageContainerRef = useRef<any>(null);
  const { title, tableBlock, menuInfo, typeObj } = props;
  const basicQueryRef = useRef<any>({});
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const { pageUtils } = useLoaderData() as any;
  const [loading, setLoading] = useState<boolean>(false);
  const [pureWidth, setPureWidth] = useState<number>(0);
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const actionParamsRef = useRef<any>({});
  const [operaLoading, setOperaLoading] = useState(false);
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

    newBlock.fields = newBlock.fields.slice(9, newBlock.fields.length);
    if (["eleme", "meituan", "douyin", "candao"].indexOf(typeObj?.channel) > -1) {
      newBlock.fields = [...bindBlockData.fields, ...newBlock.fields];
      // 删除餐道的上下架
      if (typeObj?.channel == "candao" || typeObj?.channel == "meituan") {
        newBlock.fields = newBlock.fields.filter((el: any) => el.fieldId != "itemStatus");
        newBlock.tableConfig.columnConfig = newBlock.tableConfig.columnConfig.filter(
          (el: any) => el.id != "itemStatus"
        );
      }
    } else {
      newBlock.fields = [...newBlock.fields];
    }
    newBlock.fields = newBlock.fields.filter((el: any) => el.fieldId != "mapCategoryName");
    return newBlock;
  }, [tableBlock]);

  const formBlockData = useMemo(() => {
    const blockData = pageUtils.getBlockData("QueryForm");
    const customField = pageUtils.getBlockData("QueryFormCustomFieldSyncDeleteModal");
    const _cloneData = _.cloneDeep(blockData) as any;
    if (_cloneData.fields) {
      _cloneData.fields = _cloneData.fields.filter((o: any) => {
        if (o.fieldId === "combinedFields") {
          o.componentProps.customFields = customField?.fields;
          return true;
        }
        return false;
      });
    }
    return _cloneData;
  }, [pageUtils]);
  const syncStatusOptions = useMemo(() => {
    const blockData: any = newBlockData || {};
    const options = blockData.fields?.find((item: any) => item.fieldId === "syncStatus")?.data
      ?.dataSource;
    return options;
  }, [newBlockData]);
  const itemTypeOptions = useMemo(() => {
    const blockData: any = tableBlock || {};
    const options = blockData.fields?.find((item: any) => item.fieldId === "itemType")?.data
      ?.dataSource;
    return options || [];
  }, [tableBlock]);
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { query } = params;
      if (query) {
        basicQueryRef.current = query;
      } else {
        basicQueryRef.current = {};
      }
      actionParamsRef.current = {};
      setOpen(true);
    },
  }));
  const handleOk = () => {
    //
  };
  const handleCancel = () => {
    setOpen(false);
  };
  // 批量上下架
  const batchSetMenuStatus = (
    itemIds: string[],
    enable?: boolean,
    trdSkuId?: string,
    skuidList?: string[]
  ) => {
    setLoading(true);
    const _skuidList = _.cloneDeep(skuidList);
    if (["urbanPiper", "grab"].indexOf(typeObj?.channel) > -1) {
      // up的上下架操作
      upBatchItemStatus({
        enable: enable === true ? true : false,
        itemIds: itemIds || [],
        menuId: menuInfo.menuId,
        shopId: basicQueryRef.current?.shopId,
        platform: basicQueryRef.current?.platform,
        skuItemIds: _skuidList,
      })
        .then((res: any) => {
          setLoading(false);
          const { code, data } = res;
          if (code === "000") {
            message.success(t("receipt_template.opera_success", { ns: "Restaurant" }));
            fetchData();
          }
        })
        .catch((err: any) => {
          //
          setLoading(false);
        });
    } else if (typeObj?.channel === "hungryPanda") {
      batchItemStatus({
        itemStatuses: itemIds.map((o) => {
          return {
            itemId: o,
            status: enable === true ? "on_shelf" : "off_shelf",
          };
        }),
        shopId: basicQueryRef.current?.shopId,
        platform: basicQueryRef.current?.platform,
      })
        .then((res: any) => {
          setLoading(false);
          const { code, data } = res;
          if (code === "000") {
            message.success(t("receipt_template.opera_success", { ns: "Restaurant" }));
            fetchData();
          }
        })
        .catch((err: any) => {
          //
          setLoading(false);
        });
    } else {
      setOperaLoading(true);
      elemeBatchItemStatus(
        JSON.stringify({
          listStatus: enable === true ? "1" : "0",
          shopId: basicQueryRef.current?.shopId,
          channel: typeObj?.channel,
          platform: basicQueryRef.current?.platform,
          trdDetails: [
            {
              trdItemId: itemIds[0],
              trdItemSkuId: trdSkuId,
            },
          ],
        })
      )
        .then((res) => {
          setLoading(false);
          setOperaLoading(false);
          const { code, data } = res;
          if (code === "000") {
            message.success(t("receipt_template.opera_success", { ns: "Restaurant" }));
            fetchData();
          }
        })
        .catch((err) => {
          setLoading(false);
          setOperaLoading(false);
        });
    }
  };
  const tableColumns: ITable["columns"] = [
    {
      dataIndex: "trdItemImage",
      render(value: string, record: any) {
        return value ? <Image width={100} src={value} /> : "-";
      },
    },
    {
      dataIndex: "itemImage",
      render(value: string, record: any) {
        return value ? <Image width={100} src={value} /> : "-";
      },
    },
    {
      dataIndex: "itemType",
      render(value: string, record: any) {
        const label = itemTypeOptions.find((child: any) => child.value === value)?.label || value;
        return label;
      },
    },
    {
      dataIndex: "trdItemType",
      render(value: string, record: any) {
        const val = value === "Single" ? "Item" : value;
        const label = itemTypeOptions.find((child: any) => child.value === val)?.label || value;
        return label;
      },
    },
    {
      dataIndex: "itemStatus",
      render(value: string, record: any) {
        return record.itemStatus == 1 || record.itemStatus == 0 ? (
          <Space>
            {record.itemStatus === 1
              ? t("product.statusOnSelf", { ns: "Takeaway" })
              : t("product.statusOffSelf", { ns: "Takeaway" })}
            <Switch
              checked={!!record.itemStatus}
              onChange={(evt: any) => {
                Modal.confirm({
                  title: t("common.tips", { ns: "Common" }),
                  content: t("product.confirmOperaNext", { ns: "Takeaway" }),
                  onOk() {
                    if (record.trdItemType == "Item" && record.skuId) {
                      batchSetMenuStatus([record.trdItemId], evt, record.trdSkuId, [record.skuId]);
                    } else {
                      batchSetMenuStatus([record.trdItemId], evt, record.trdSkuId, []);
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
    tableRef.current?.setTableData([]);
    if (!actionParamsRef.current?.shopId) {
      tableRef.current?.setPagination({
        current: 1,
        total: 0,
      });
      return;
    }
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
          if (["eleme", "meituan", "douyin", "candao"].indexOf(typeObj?.channel) > -1) {
            // 国内的都是绑定状态，且都应该是未绑定
            newItem.bindStatus = t("product.bindStatusNo", { ns: "Takeaway" }); // 这里写死了，是未绑定，没有从枚举里取
          } else {
            newItem.syncStatus =
              syncStatusOptions?.find((child: any) => child.value === item.syncStatus)?.label || "";
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
          // console.log(90909, newItem);
          return newItem;
        });
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
    if (["urbanPiper", "grab", "chowly"].indexOf(typeObj?.channel) > -1) {
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
    } else if (basicQueryRef.current?.platform === "hungryPanda") {
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
      elemeQueryPageUnbindItems({
        ...actionParamsRef.current,
        channel: basicQueryRef.current?.channel,
      })
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
    }
  };
  // 字段转换
  const filterTo: any = {
    trdItemName: "trdItemName",
    trdItemNameLike: "trdItemNameLike",
  };
  const actionCallback = (actionProps: IComposeTreeTableActionCallbackProps) => {
    // 对组合式筛选项做处理
    if (actionProps.formData?.combinedFields) {
      actionProps.formData[actionProps.formData.combinedFields?.fieldId] =
        actionProps.formData.combinedFields?.value;
      delete actionProps.formData.combinedFields;
    }
    if (actionProps.formData?.trdItemName) {
      actionProps.formData.trdItemNameLike = actionProps.formData?.trdItemName;
    }
    const actionParams: IKVProps = {
      platform: basicQueryRef.current?.platform,
      shopId: basicQueryRef.current?.shopId,
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
    setPureWidth(pageContainerRef?.current ? pageContainerRef?.current?.clientWidth : 0);
  };
  return (
    <>
      <Modal
        title={<div>{title}</div>}
        open={open}
        onOk={handleOk}
        destroyOnClose={true}
        footer={() => {
          return (
            <>
              <Button
                type="primary"
                onClick={() => {
                  handleCancel();
                }}
              >
                {t(CommonEnum.Close, { ns: "Common" })}
              </Button>
            </>
          );
        }}
        width={"80%"}
        onCancel={handleCancel}
      >
        <div className="pt-[20px]" ref={pageContainerRef}>
          {open && (
            <ComposeTreeTable
              memoryAction={false}
              ref={tableRef}
              formConfig={{
                blockData: formBlockData,
                showReset: true,
                bottomSlot: <div className="flex justify-between mb-[10px]"></div>,
              }}
              tableConfig={{
                blockData: newBlockData,
                columns: tableColumns,
                rowKey: "itemId",
                showOperationColumn: true,
                pureWidth: pureWidth - 40,
                extraProps: {
                  loading: loading,
                },
              }}
              actionCallback={actionCallback}
            />
          )}
        </div>
      </Modal>
    </>
  );
});

export default View;
