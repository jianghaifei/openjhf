import { Button, Modal } from "antd";
import { useRef, useState, forwardRef, useImperativeHandle } from "react";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
import { useLoaderData } from "react-router-dom";
import { IKVProps } from "@restosuite/field-core";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import { useTranslation } from "react-i18next";
import { queryPublishDetail } from "@src/Api/Takeaway/StoreAndItems";
import dayjs from "dayjs";
import StatusItem from "./RecordStatusItem";

export type IRecordDetailRef = {
  open: (params: any) => void;
};
const ShopListModal = forwardRef<IRecordDetailRef, any>((props, ref) => {
  const { title, openPublish } = props;
  const { pageUtils } = useLoaderData() as any;
  const { t } = useTranslation();
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const [open, setOpen] = useState<boolean>(false);
  const queryRef = useRef<IKVProps>({
    page: {
      pageNo: 1,
      pageSize: 10,
    },
  });
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { publishId } = params;
      const newObj = { ...queryRef.current };
      newObj.publishId = publishId || "";
      queryRef.current = newObj;
      setOpen(true);
    },
  }));
  const requestList = () => {
    queryPublishDetail({ ...queryRef.current }).then((res) => {
      const { data, code } = res;
      if (code === "000") {
        tableRef.current?.setTableData(data.details);
        tableRef.current?.setPagination({
          current: data.page?.pageNo || 1,
          total: data.page?.total,
          pageSize: data.page?.pageSize || 10,
        });
      }
    });
  };

  const actionCallback = (actionProps: IComposeTreeTableActionCallbackProps) => {
    const actionParams = {
      ...queryRef.current,
      page: {
        pageNo: actionProps.pageNo,
        pageSize: actionProps.pageSize,
      },
      filter: {
        ...actionProps.formData,
      },
    };
    if (actionParams.filter.completeDate && actionParams.filter.completeDate.length === 2) {
      actionParams.filter.completeDateFrom = dayjs(actionParams.filter.completeDate[0])
        .startOf("day")
        .format();
      actionParams.filter.completeDateTo = dayjs(actionParams.filter.completeDate[1])
        .endOf("day")
        .format();
      delete actionParams.filter.completeDate;
    }
    queryRef.current = actionParams;
    requestList();
  };

  const columns = [
    {
      dataIndex: "status",
      render(value: string, record: any) {
        return <StatusItem label={record.statusName} value={record.status} />;
      },
    },
    {
      dataIndex: "publishType",
      render(value: string, record: any) {
        if (value === "full") {
          return t("Common.Delete", { ns: "Customers" });
        } else if (value === "update") {
          return t("takeaway.labelReserve", { ns: "Takeaway" });
        }
        return "-";
      },
    },
    {
      dataIndex: "publishOrg",
      render(value: string, record: any) {
        if (value === "corp") {
          return t("common.Corporation", { ns: "Common" });
        } else if (value === "shop") {
          return t("common.Locations", { ns: "Common" });
        }
        return "-";
      },
    },
    {
      dataIndex: "postDetails",
      render(value: string, record: any) {
        const okCount = (record.itemCount || 0) - (record.failedCount || 0);
        return (
          <Button
            type="link"
            onClick={() => {
              openPublish(record.id);
            }}
          >
            {okCount}/{record.itemCount || 0}
          </Button>
        );
      },
    },
  ];
  return (
    <Modal
      width="90%"
      open={open}
      title={title}
      className={`${stylesModel.customModal}`}
      footer={false}
      destroyOnClose={true}
      onCancel={() => {
        setOpen(false);
      }}
    >
      {open && (
        <div className="pt-3">
          <ComposeTreeTable
            ref={tableRef}
            formConfig={{
              blockData: pageUtils.getBlockData("DetailQueryForm"),
              showReset: true,
              bottomSlot: <div className="flex justify-between mb-[10px]"></div>,
            }}
            tableConfig={{
              blockData: pageUtils.getBlockData("DetailTableList"),
              rowKey: "dataId",
              columns,
              showOperationColumn: false,
            }}
            actionCallback={actionCallback}
          />
        </div>
      )}
    </Modal>
  );
});

export default ShopListModal;
