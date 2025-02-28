// 外卖菜单弹层
import { Button, Modal, message, Input, Spin, Space } from "antd";
import { useRef, useState, useImperativeHandle, useEffect, forwardRef } from "react";
import { useLoaderData } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import { ITable } from "@src/Components/Table/ITable";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import { getCurrencySymbol } from "@src/Utils/CommonUtils";
import { getMapdata, bindAndUnbind, existenceOrnot } from "../../Components/IHelper";
import _ from "lodash";
import { trdItemQuery } from "@src/Api/Takeaway/takeoutDelivery";
import ThirdItemsLoad from "./ThirdItemsLoad";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
import styles from "./index.module.less";
const { Search } = Input;
export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { title, query, onChange, typeObj, menuInfo, channelShopId, itemTypeOptions } = props;
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const { pageUtils } = useLoaderData() as any;
  const [treeData, setTreeData] = useState<any>([]);
  const sourceDataRef = useRef<any>([]);
  const [tableData, setTableData] = useState<any[]>([]);
  const recordRef = useRef<any>({});
  const [loading, setLoading] = useState<boolean>(false);
  const [fetchLoading, setFetchLoading] = useState<boolean>(false);
  const selectedRowsRef = useRef<any[]>([]);
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const [queryVal, setQueryVal] = useState<string>("");
  const [type, setType] = useState<any>("checkbox");
  const [shopList, setShopList] = useState<any>([]);
  const [rightDishs, setRightDishs] = useState<any>([]);
  const pageContainerRef = useRef<any>(null);
  const [selectedRowKeys, setSelectedRowKeys] = useState<any>();
  const [saveSelectKey, setSaveSelectKey] = useState<any>([]);
  const [oldBindDtata, setOldBindDtata] = useState([]);
  const [disableThirdItem, setDisableThirdItem] = useState<any>([]);
  const [synchronization, setSynchronization] = useState(true);
  const [init, setInit] = useState(false);
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      setInit(false);
      setTreeData(null);
      setQueryVal("");
      selectedRowsRef.current = [];
      sourceDataRef.current = [];
      if (params.record) {
        recordRef.current = params.record;
        setSelectedRowKeys([]);

        getAlllist(_.cloneDeep(params), [], params.record.leftnid);
      }
      setType(params.type || "checkbox");
      setOpen(true);
      getItems();
    },
  }));
  // 获取全部的本地菜品
  const getAlllist = (params: any, bingData: any, leftnid: any) => {
    const { queryData, total } = params;
    queryData.itemFilter = {
      itemNameLike: params.record.itemName,
    };
    queryData.itemNameLike = params.record.itemName;
    queryData.trd = {
      itemNameLike: params.record.itemName,
      channelShopId: channelShopId,
    };
    getMapdata(queryData, (res: any) => {
      const { code, list, page, notBindCount } = res;
      setShopList(list);
      const disableList: any = [];

      const currentData = list.find((el: any) => el.leftnid == leftnid);
      const selectKyys = currentData.nid;
      const bingData = currentData.trdItems;
      setOldBindDtata(bingData);
      selectedRowsRef.current = bingData;
      list.forEach((el: any) => {
        if (el.trdItems && el.trdItems.length > 0) {
          el.trdItems.forEach((item: any) => {
            if (!bingData.map((el: any) => el.nid).includes(item.nid)) {
              disableList.push(item.nid);
            }
          });
        }
      });
      setSelectedRowKeys(selectKyys);
      // setDisableThirdItem(disableList);
    });
  };
  const handleOk = () => {
    let _selectedRows = _.cloneDeep(selectedRowsRef.current);
    if (_selectedRows.length === 0) {
      message.warning(t("tags.itemRequired", { ns: "Member" }));
      return;
    }
    _selectedRows = _selectedRows.map((el: any, index: number) => {
      if (!el && selectedRowKeys[index]) {
        el = tableData.find((n: any) => n.nid == selectedRowKeys[index]);
      }
      return el;
    });
    // 检测是否符合绑定条件
    // if (
    //   !_selectedRows
    //     .map((el: any) => {
    //       if (existenceOrnot(el.nid, recordRef.current.leftnid, shopList, rightDishs)) {
    //         return false;
    //       }
    //       return true;
    //     })
    //     .every((item) => item)
    // ) {
    //   return;
    // }
    // 多选的三方菜是否相同菜，不同规格，可能选中不同的多规格三方菜，上面的验证不会拦截
    // if (!_selectedRows.every((item) => item.trdItemId == _selectedRows[0].trdItemId)) {
    //   // return message.warning("一个菜品只能绑定一个三方菜品的不同规格，不能同时绑定多个三方商品");
    //   return message.warning(t("instant.bindingUniqueness", { ns: "Takeaway" }));
    // }
    setLoading(true);

    const idsToRemove = new Set(_selectedRows.map((item: any) => item.nid));
    const undata = oldBindDtata.filter((item: any) => !idsToRemove.has(item.nid));

    console.log("绑定", _selectedRows);
    console.log("解绑", undata);

    bindAndUnbind(
      channelShopId,
      menuInfo.menuId,
      [
        ..._selectedRows.map((el: any) => {
          return {
            trdItemId: el.trdItemId,
            trdUnitId: el.trdUnitId,
            trdItemName: el.trdItemName,
            itemId: recordRef.current.itemId,
            itemName: recordRef.current.itemName,
            unitId: recordRef.current.unitId,
            unitName: recordRef.current.unitName,
          };
        }),
        ...undata.map((el: any) => {
          return {
            trdItemId: el.trdItemId,
            trdUnitId: el.trdUnitId,
            trdItemName: el.trdItemName,
            itemId: null,
            itemName: recordRef.current.itemName,
            unitId: recordRef.current.unitId,
            unitName: recordRef.current.unitName,
          };
        }),
      ],
      false,
      (res: any) => {
        setLoading(false);
        if (res.code == "000") {
          message.success(t("receipt_template.opera_success", { ns: "Restaurant" }));
          handleCancel();
          onChange();
        }
      }
    );
  };
  const handleCancel = () => {
    setOpen(false);
  };
  const tableColumns: ITable["columns"] = [
    {
      dataIndex: "trdItemType",
      render(value: any, record: any) {
        if (value == "Single") {
          value = "Item";
        }
        return value && value != "-" ? (
          <div>
            {itemTypeOptions.find((child: any) => child.value === value)?.label || value || "-"}
          </div>
        ) : (
          "-"
        );
      },
    },
    {
      dataIndex: "trdItemSizeName",
      render(value: any, record: any) {
        value = record.trdUnitName;
        return value && value != "-" ? value : "-";
      },
    },
  ];
  const getItems = () => {
    setFetchLoading(true);
    setTableData([]);
    setTreeData(null);
    trdItemQuery({
      channelShopId,
    })
      .then((res: any) => {
        setFetchLoading(false);
        const { code, data } = res;
        if (code === "000") {
          const treeList: any = [];
          const allitemlist: any = data.list.map((el: any) => {
            el.fileval = Object.values(el).join("");
            if (!treeList.find((o: any) => o.name == el.trdCategoryName)) {
              treeList.push({
                name: el.trdCategoryName,
                index: el.trdCategoryId,
              });
            }
            el.nid = el.trdItemId + el.trdUnitId;
            return el;
          });
          setRightDishs(allitemlist);
          treeList.unshift({
            name: t("marketing.all", { ns: "Marketing" }),
            index: "",
          });
          setTreeData(treeList);
        } else {
          //
        }
      })
      .catch((e) => {
        setFetchLoading(false);
      });
  };
  const actionCallback = (actionProps: IComposeTreeTableActionCallbackProps) => {
    if (actionProps.treeRows && actionProps.treeRows.length > 0) {
      const filkey: any = actionProps.treeRows;
      const dataObj = rightDishs.filter((o: any) =>
        filkey[0].index ? o.trdCategoryName == filkey[0].name : o
      );
      if (dataObj) {
        const currencySymbol = getCurrencySymbol();
        setTableData(
          dataObj?.map((item: any) => {
            return {
              ...item,
              // 查询的文本
              queryValue: item.trdItemName || "",
              trdPrice: item.trdPrice ? `${currencySymbol}${item.trdPrice}` : "",
              trdPriceNew: item.trdPrice,
            };
          })
        );
      }
    } else {
      setTableData([]);
    }
  };
  useEffect(() => {
    if (open) {
      if (tableData.length) {
        if (!queryVal) {
          setSynchronization(false);
        } else {
          setSynchronization(true);
        }
        const filterItems = tableData.filter((o: any) => o.fileval.indexOf(queryVal) > -1);
        tableRef.current?.setTableData(filterItems);
        // setInit(true);
      } else {
        tableRef.current?.setTableData([]);
      }
    }
  }, [queryVal, tableData]);
  return (
    <>
      <Modal
        title={
          <div>
            {title}{" "}
            <ThirdItemsLoad
              type="2"
              channelShopId={channelShopId}
              onChange={() => {
                getItems();
              }}
            />
          </div>
        }
        open={open}
        destroyOnClose={true}
        className={`${stylesModel.customModal} ${stylesModel.customModalBind}`}
        width={"800px"}
        onCancel={handleCancel}
        footer={
          <div style={{ padding: "0 8px 0 16px" }}>
            <Space>
              <Button key="back" onClick={handleCancel}>
                {t(CommonEnum.CANCEL, { ns: "Common" })}
              </Button>
              <Button key="submit" loading={loading} type="primary" onClick={handleOk}>
                {t(CommonEnum.CONFIRM, { ns: "Common" })}
              </Button>
            </Space>
          </div>
        }
      >
        <div
          ref={pageContainerRef}
          style={{ height: "445px", marginTop: "10px", overflow: "hidden", padding: "0 7px" }}
        >
          <Spin spinning={fetchLoading}>
            <div style={{ height: "445px" }} className={styles.composeTreeTableTree}>
              <div className="divcheck" style={{ height: "445px" }}>
                {open && treeData ? (
                  <ComposeTreeTable
                    memoryAction={false}
                    ref={tableRef}
                    layout="Horizontal"
                    treeConfig={{
                      data: treeData,
                      disableDeSelection: true,
                      extraProps: {
                        fieldNames: {
                          title: "name",
                          key: "index",
                          children: "children",
                        },
                      },
                    }}
                    tableConfig={{
                      blockData: pageUtils.getBlockData("ItemTableList"),
                      columns: tableColumns,
                      rowKey: "nid",
                      showOperationColumn: false,
                      // showIndexColumn: true,
                      pureHeight: 320,
                      pureWidth: pageContainerRef?.current?.clientWidth - 300,
                      topSlot: (
                        <div className="mb-[15px] mt-[15px]">
                          <Search
                            placeholder={t("common.search", { ns: "Common" })}
                            value={queryVal}
                            onChange={(evt: any) => {
                              setQueryVal(evt.target.value);
                            }}
                          />
                        </div>
                      ),
                      extraProps: {
                        locale:
                          !synchronization && init
                            ? {
                                emptyText: (
                                  <ThirdItemsLoad
                                    type="1"
                                    channelShopId={channelShopId}
                                    onChange={() => {
                                      getItems();
                                    }}
                                  />
                                ),
                              }
                            : {},
                        loading: fetchLoading,
                        rowSelection: {
                          getCheckboxProps: (record: any) => {
                            return {
                              disabled: disableThirdItem.includes(record.nid),
                            };
                          },
                          preserveSelectedRowKeys:
                            selectedRowsRef.current && selectedRowsRef.current.length > 0
                              ? true
                              : false, // 保持选中状态
                          selectedRowKeys: selectedRowKeys,
                          type: type,
                          onChange: (selectedRowKeys: any, selectedRows: any) => {
                            setSelectedRowKeys(selectedRowKeys);
                            selectedRowsRef.current = selectedRows;
                            console.log("selectedRowKeys", selectedRows);
                          },
                        },
                      },
                    }}
                    pagination={{
                      visible: false,
                    }}
                    actionCallback={actionCallback}
                  />
                ) : (
                  ""
                )}
              </div>
            </div>
          </Spin>
        </div>
      </Modal>
    </>
  );
});

export default View;
