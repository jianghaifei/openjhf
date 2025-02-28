// 外卖菜单弹层
import { Button, Modal, message, Input, Space } from "antd";
import { useRef, useState, useImperativeHandle, useEffect, forwardRef, useMemo } from "react";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import { ITable } from "@src/Components/Table/ITable";
import styles from "./index.module.less";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
import { shopPageShop } from "@src/Api/Takeaway/StoreAndItems";
import { mappingCopy } from "@src/Api/Takeaway/takeoutDelivery";
import { asyncGetPageMetaUtils } from "@src/Utils/PageMetaHelper";
import PageMetaUtils from "@src/Utils/PageMetaUtils";
const { Search } = Input;
export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const [pageUtils, setPageUtils] = useState<PageMetaUtils | undefined>(undefined);
  const queryRef = useRef<any>({});
  const activeRows = useRef<any[]>([]);
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const [saveLoading, setSaveLoading] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    asyncGetPageMetaUtils("StoreBinding").then((res: PageMetaUtils) => {
      setPageUtils(res);
    });
  }, []);

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      activeRows.current = [];
      queryRef.current = { ...params };
      setOpen(true);
    },
  }));

  const tableBlock = useMemo(() => {
    if (pageUtils) {
      const TableList: any = pageUtils?.getBlockData("TableList");
      TableList.fields = TableList.fields.filter((el: any) =>
        ["shopId", "shopName", "selectedMenuName"].includes(el.fieldId)
      );
      TableList.fields.push({
        fieldType: "Text",
        title: t("product.labelDlMenus", { ns: "Takeaway" }),
        fieldId: "selectedMenuName",
      });
      TableList.tableConfig.columnConfig = TableList.fields.map((item: any) => {
        return {
          id: item.fieldId,
          minWidth: 200,
        };
      });
      return TableList;
    }
  }, [pageUtils]);

  const formBlockData = useMemo(() => {
    if (pageUtils) {
      const blockData: any = pageUtils?.getBlockData("QueryFormCustomField");
      blockData.fields = blockData?.fields.filter((el: any) =>
        ["shopId", "shopName"].includes(el.fieldId)
      );
      return blockData;
    }
  }, [pageUtils]);

  const handleOk = () => {
    if (activeRows.current && activeRows.current.length === 0) {
      message.warning(t("secondaryScreen.pleaseSelectStore", { ns: "Restaurant" }));
      return;
    }
    const values = {
      channelShopId: queryRef.current.channelShopId,
      targets: activeRows.current.map((v: any) => v.id),
    };
    setSaveLoading(true);
    mappingCopy(values)
      .then((res: any) => {
        setSaveLoading(false);
        if (res.code != "000") {
          return;
        }
        message.success(t("trdAccount.Copycomplete", { ns: "Takeaway" }));
        handleCancel();
      })
      .catch(() => {
        setSaveLoading(false);
      });
  };

  const handleCancel = () => {
    setOpen(false);
  };

  const tableColumns: ITable["columns"] = [];

  const actionCallback = (actionProps: IComposeTreeTableActionCallbackProps) => {
    const actionParams: any = {
      page: {
        pageNo: actionProps.pageNo,
        pageSize: actionProps.pageSize,
      },
      ...actionProps.formData,
    };
    if (actionParams.shopName) {
      actionParams.shopNameLike = actionParams.shopName || "";
      delete actionParams.shopName;
    }
    if (actionParams.shopId) {
      actionParams.shopIds = [actionParams.shopId];
      delete actionParams.shopId;
    }
    console.log("aaaaaa", actionParams);
    setLoading(true);
    shopPageShop({
      platform: queryRef.current.platform,
      ...actionParams,
      businesses: ["takeOut"],
    })
      .then((res: any) => {
        setLoading(false);
        if (res.code != "000") {
          return;
        }
        const list = (res.data && res.data.list) || [];
        const dataLiat: any = [];
        list.forEach((el: any) => {
          el.channels.forEach((item: any) => {
            dataLiat.push({
              ...item,
              ...el.shop,
            });
          });
        });
        tableRef.current?.setTableData(dataLiat);
        tableRef.current?.setPagination({
          current: res.data.page?.pageNo || 1,
          pageSize: res.data.page?.pageSize || 10,
          total: res.data.page?.total,
        });
      })
      .catch(() => {
        setLoading(false);
      });
  };
  return (
    <>
      <Modal
        title={t("locationclone.selectlocation", { ns: "BaseServe" })}
        className={`${stylesModel.customModal}`}
        open={open}
        destroyOnClose={true}
        width={"1000px"}
        onCancel={handleCancel}
        footer={
          <div className={styles.footerClass} style={{ padding: "0 8px" }}>
            <Space>
              <Button key="back" onClick={handleCancel}>
                {t(CommonEnum.CANCEL, { ns: "Common" })}
              </Button>

              <Button key="submit" loading={saveLoading} type="primary" onClick={handleOk}>
                {t(CommonEnum.Confirm, { ns: "Common" })}
              </Button>
            </Space>
          </div>
        }
      >
        <ComposeTreeTable
          ref={tableRef}
          layout="Horizontal"
          formConfig={{
            blockData: formBlockData,
            showReset: true,
          }}
          tableConfig={{
            blockData: tableBlock,
            columns: tableColumns,
            rowKey: "id",
            showOperationColumn: false,
            showIndexColumn: true,
            extraProps: {
              loading: loading,
              rowSelection: {
                type: "checkbox",
                onChange: (selectedRowKeys: any, selectedRows: any) => {
                  activeRows.current = selectedRows;
                },
                getCheckboxProps: (record: any) => ({
                  disabled:
                    record.id === queryRef.current.channelShopId || !record.selectedMenuName,
                }),
              },
            },
          }}
          actionCallback={actionCallback}
        />
      </Modal>
    </>
  );
});

export default View;
