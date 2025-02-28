// 外卖菜单弹层
import { Button, Modal, message, Space } from "antd";
import {
  useRef,
  useState,
  useImperativeHandle,
  forwardRef,
  useMemo,
} from "react";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import styles from "./index.module.less";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
import { ILoaderData } from "@src/Router/GenerateRoutes";
import { useLoaderData } from "react-router-dom";
import { useStore } from "@src/Store";
import {
  deliveryQuery,
  deliverySaveConfigs,
} from "@src/Api/Takeaway/AggregateManagement";
import _ from "lodash";
export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const queryRef = useRef<any>({});
  const activeRows = useRef<any[]>([]);
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const [saveLoading, setSaveLoading] = useState(false);
  const [loading, setLoading] = useState(false);
  const { pageUtils } = useLoaderData() as ILoaderData;
  const { loginStore } = useStore();
  const [shopId, setShopId] = useState("");

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      activeRows.current = [];
      setShopId(params.shopId);
      setOpen(true);
    },
  }));

  const tableBlock = useMemo(() => {
    if (pageUtils) {
      const TableList: any = pageUtils?.getBlockData("TableList");
      return TableList;
    }
  }, [pageUtils]);

  const formBlockData = useMemo(() => {
    if (pageUtils) {
      const blockData: any = pageUtils?.getBlockData("QueryForm");
      return blockData;
    }
  }, [pageUtils]);

  const handleOk = () => {
    if (activeRows.current && activeRows.current.length === 0) {
      message.warning(
        t("secondaryScreen.pleaseSelectStore", { ns: "Restaurant" })
      );
      return;
    }
    // console.log("qqqq", queryRef.current, activeRows.current);
    const values = {
      corporationId: loginStore.getCorporationId(),
      shopId: shopId,
      ruleId: (activeRows.current.map((el: any) => el.ruleId) || [])[0],
    };
    setSaveLoading(true);
    deliverySaveConfigs(values)
      .then((res: any) => {
        setSaveLoading(false);
        // console.log("ddddd", res);
        if (res.code != "000") {
          return;
        }
        message.success(res.msg);
        props.onChange?.();
        setOpen(false);
      })
      .catch(() => {
        setSaveLoading(false);
      });
  };

  const handleCancel = () => {
    setOpen(false);
  };

  const actionCallback = (actios: IComposeTreeTableActionCallbackProps) => {
    const actionProps: IComposeTreeTableActionCallbackProps =
      _.cloneDeep(actios);
    console.log("actionCallback", actionProps);
    queryRef.current = actionProps;
    fetchData();
  };

  const fetchData = (info?: any) => {
    setLoading(true);
    deliveryQuery({
      page: {
        pageNo: queryRef.current.pageNo,
        pageSize: queryRef.current.pageSize,
      },
      ...queryRef.current.formData,
    })
      .then((res: any) => {
        setLoading(false);
        // console.log("gggg", res);
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

  const tableColumns: any = () => {
    return [
      {
        dataIndex: "shopId",
        sorter: (a: any, b: any) => a.shopId.localeCompare(b.shopId),
        render: (value: number, record: any) => {
          return value;
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
            return t("aggregate.close", { ns: "Takeaway" });
          }
        },
      },
    ];
  };

  return (
    <>
      <Modal
        title={t("aggregate.distributionruleselection", { ns: "Takeaway" })}
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

              <Button
                key="submit"
                loading={saveLoading}
                type="primary"
                onClick={handleOk}
              >
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
            resetCallback: () => {
              queryRef.current = { pageSize: 10, pageNo: 1 };
              fetchData();
            },
          }}
          tableConfig={{
            blockData: tableBlock,
            columns: tableColumns(),
            rowKey: "ruleId",
            showOperationColumn: false,
            showIndexColumn: true,
            extraProps: {
              loading: loading,
              rowSelection: {
                type: "radio",
                onChange: (selectedRowKeys: any, selectedRows: any) => {
                  activeRows.current = selectedRows;
                },
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
