// 外卖菜单弹层
import { Button, Modal, message, Input, Space } from "antd";
import { useRef, useState, useImperativeHandle, useEffect, forwardRef } from "react";
import { useLoaderData } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import { ITable } from "@src/Components/Table/ITable";
import styles from "./index.module.less";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import useCustomNavigate from "@src/Hooks/useCustomNavigate";
import ConfimModel from "@src/pages/Takeaway/StoreBinding/Components/ConfimModel";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";

const { Search } = Input;
export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { dispatchNavigate } = useCustomNavigate();
  const { title, onChange, menuInfo, menuTree, typeObj, onCloseTakeaway } = props;
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const { pageUtils } = useLoaderData() as any;
  const [queryVal, setQueryVal] = useState<string>("");
  const queryRef = useRef<any>({});
  const confimModelref = useRef<any>({});
  const activeRows = useRef<any[]>([]);
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const [select, setSelect] = useState<any>(null);
  const [saveLoading, setSaveLoading] = useState(false);
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      setQueryVal("");
      if (menuTree && menuTree.length === 0) {
        confimModelref.current.open({
          title: "",
          icon: "",
          width: 500,
          buttonText: "",
          buttonList: [
            <Button
              type="primary"
              onClick={() => {
                confimModelref.current.destroy();
              }}
            >
              {t("product.btnOk", { ns: "Takeaway" })}
            </Button>,
          ],
          text: t("product.textStoreNoMenu", {
            ns: "Takeaway",
            n: typeObj.label,
          }),
        });
        return;
      }
      queryRef.current = { ...params };
      activeRows.current = [
        {
          ...menuInfo,
          dataId: menuInfo.menuId,
        },
      ];
      if (menuInfo && JSON.stringify(menuInfo) != "{}" && menuInfo.menuId) {
        setSelect({
          ...menuInfo,
          dataId: menuInfo.menuId,
        });
      } else {
        setSelect(null);
      }
      setOpen(true);
    },
  }));
  const handleOk = () => {
    if (activeRows.current && activeRows.current.length === 0) {
      message.warning(t("Takeaway.selectTakeawayMenu", { ns: "Takeaway" }));
      return;
    }

    if (select && activeRows.current[0].dataId == select.menuId) {
      handleCancel();
      if (queryRef.current.isPiliang) {
        onCloseTakeaway?.(queryRef.current);
      }
      return;
    }

    if (!select) {
      onChange(activeRows.current);
      handleCancel();
      if (queryRef.current.isPiliang) {
        onCloseTakeaway?.(queryRef.current);
      }
      return;
    }

    confimModelref.current.open({
      title: "",
      icon: "",
      width: 500,
      buttonText: "",
      buttonList: [
        <Button
          onClick={() => {
            confimModelref.current.destroy();
          }}
        >
          {t("Common.Cancel", { ns: "Customers" })}
        </Button>,
        <Button
          type="primary"
          onClick={() => {
            handleCancel();
            confimModelref.current.destroy();
            if (queryRef.current.isPiliang) {
              onCloseTakeaway?.(queryRef.current);
            }
            onChange(activeRows.current);
          }}
        >
          {t("Confirm", { ns: "Common" })}
        </Button>,
      ],
      text: t("takeaway.confirmTxtChangeMenu", { ns: "Takeaway" }),
    });
    // Modal.confirm({
    //   title: t("common.tips", { ns: "Common" }),
    //   content: t("takeaway.confirmTxtChangeMenu", { ns: "Takeaway" }),
    //   onOk() {
    //     // onChange(activeRows.current);
    //     handleCancel();
    //     if (queryRef.current.isPiliang) {
    //       onCloseTakeaway && onCloseTakeaway(queryRef.current);
    //     }
    //   },
    // });
  };
  const handleCancel = () => {
    setOpen(false);
  };
  const tableColumns: ITable["columns"] = [];
  const filterData = () => {
    if (menuTree && menuTree.length > 0) {
      const list = menuTree
        .filter((o: any) => o.name.indexOf(queryVal) > -1)
        .map((item: any) => {
          return {
            dataId: item.dataId,
            menuId: item.dataId,
            menuName: item.name,
            menuCount: item.menuGroups ? item.menuGroups.length : 0,
            describe: "",
          };
        });
      tableRef.current?.setTableData(list);
    }
  };
  useEffect(() => {
    filterData();
  }, [queryVal]);
  const actionCallback = (actionProps: IComposeTreeTableActionCallbackProps) => {
    const actionParams = {
      page: {
        pageNo: actionProps.pageNo,
        pageSize: actionProps.pageSize,
      },
      ...actionProps.formData,
    };
    filterData();
  };
  return (
    <>
      <Modal
        title={
          <div>
            <div>{title}</div>
          </div>
        }
        className={`${stylesModel.customModal}`}
        open={open}
        destroyOnClose={true}
        width={"800px"}
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
        <div style={{ padding: "10px 10px" }}>
          {menuInfo && menuInfo.menuId && (
            <div className="text-[12px] font-normal" style={{ padding: "0 16px 8px 16px" }}>
              {t("product.labelActiveMenuName", { ns: "Takeaway" })}：{menuInfo.menuName}（ID：
              {menuInfo.menuId}）
            </div>
          )}
          <div className="pl-[15px] pr-[15px] mb-[15px]">
            <Search
              placeholder={t("common.search", { ns: "Common" })}
              onChange={(evt: any) => {
                setQueryVal(evt.target.value);
              }}
            />
          </div>
          <ComposeTreeTable
            ref={tableRef}
            layout="Horizontal"
            tableConfig={{
              blockData: pageUtils.getBlockData("MenuTableList"),
              columns: tableColumns,
              rowKey: "dataId",
              showOperationColumn: false,
              showIndexColumn: true,
              extraProps: {
                rowSelection: {
                  type: "radio",
                  onChange: (selectedRowKeys: any, selectedRows: any) => {
                    activeRows.current = selectedRows;
                    console.log("selectedRowKeys", selectedRowKeys, "selectedRows", selectedRows);
                  },
                  getCheckboxProps: (record: any) => ({
                    disabled: record.dataId === menuInfo.menuId,
                  }),
                },
              },
            }}
            pagination={{
              visible: false,
            }}
            actionCallback={actionCallback}
          />
        </div>
      </Modal>
      <ConfimModel ref={confimModelref} />
    </>
  );
});

export default View;
