import { Modal, Alert } from "antd";
import { useMemo, useRef, useState, forwardRef, useImperativeHandle } from "react";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
import { useLoaderData } from "react-router-dom";
import { IKVProps } from "@restosuite/field-core";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import { useTranslation } from "react-i18next";
import { queryPublishResult } from "@src/Api/Takeaway/StoreAndItems";

export type IPublishResultDetailRef = {
  open: (params: any) => void;
};
const ShopListModal = forwardRef<IPublishResultDetailRef, any>((props, ref) => {
  const { title, formBlock, tableBlock } = props;
  const { pageUtils } = useLoaderData() as any;
  const { t } = useTranslation(["Restaurant"]);
  const [queryForm, setQueryForm] = useState<any>({});
  const [publishItemDetail, setPublishItemDetail] = useState<any>({});
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const [open, setOpen] = useState<boolean>(false);
  const [list, setList] = useState<any[]>([]);
  const queryRef = useRef<IKVProps>({
    page: {
      pageNo: 1,
      pageSize: 10,
    },
  });
  const tableBlockData = useMemo(() => {
    return pageUtils.getBlockData("ResultTableList");
  }, [pageUtils]);
  const itemTypeOptions = useMemo(() => {
    const blockData: any = tableBlockData || {};
    const options = blockData.fields?.find((item: any) => item.fieldId === "itemType")?.data
      ?.dataSource;
    return options || [];
  }, [tableBlockData]);
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { publishDetailId } = params;
      const newObj = { ...queryRef.current };
      newObj.publishDetailId = publishDetailId || "";
      queryRef.current = newObj;
      setOpen(true);
    },
  }));
  const requestList = () => {
    queryPublishResult({ ...queryRef.current })
      .then((res) => {
        const { data, code } = res;
        if (code === "000") {
          const { items = [], failedItems = [] } = data || {};
          if (data?.publishItemDetail) {
            setPublishItemDetail(JSON.parse(data.publishItemDetail));
          }
          const filterList = items.filter((item: any) => {
            return failedItems.find((child: any) => {
              if (child.posItemId.indexOf("/") > -1) {
                const ids = child.posItemId.split("/");
                if (ids[ids.length - 1] === item.itemId) {
                  // 失败原因同步过去
                  item.reason = child.reason;
                  return true;
                } else {
                  return false;
                }
              }
              return false;
            });
          });
          const newList = filterList.map((item: any) => {
            return {
              ...item,
              itemImage: item.imageUrl,
              itemSizeName: item.sizeNames,
              price: item.basePrice,
            };
          });
          tableRef.current?.setTableData(newList);
          setList(newList);
          tableRef.current?.setPagination({
            current: data?.page?.pageNo || 1,
            total: data?.page?.total,
            pageSize: data?.page?.pageSize || 10,
          });
        }
      })
      .catch((e) => {
        setList([]);
      });
  };

  const actionCallback = (actionProps: IComposeTreeTableActionCallbackProps) => {
    const newObj = {
      ...queryRef.current,
      page: {
        pageNo: actionProps.pageNo,
        pageSize: actionProps.pageSize,
      },
      ...actionProps.formData,
    };
    queryRef.current = newObj;
    requestList();
  };

  const columns = [
    {
      dataIndex: "status",
      render(value: string, record: any) {
        return <div>{record.statusName}</div>;
      },
    },
    {
      dataIndex: "itemType",
      render(value: string, record: any) {
        const label = itemTypeOptions.find((child: any) => child.value === value)?.label || value;
        return label;
      },
    },
  ];
  return (
    <Modal
      width="800px"
      open={open}
      title={title}
      destroyOnClose={true}
      className={`${stylesModel.customModal}`}
      onCancel={() => {
        setOpen(false);
      }}
      footer={null}
    >
      {open && (
        <div className="p-[20px]">
          <div className="pt-[15px] pb-[15px]">
            <Alert
              message=""
              description={t("takeaway.txtPublishTips", {
                ns: "Takeaway",
                a: publishItemDetail.comboCount || "0",
                b: publishItemDetail.itemCount || "0",
                c: publishItemDetail.skuCount || "0",
              })}
              type="info"
              showIcon
            />
          </div>
          <div
            style={{
              display: list.length > 0 ? "block" : "none",
            }}
          >
            <div className="pb-[15px]">{t("takeaway.labelPublishError", { ns: "Takeaway" })}：</div>
            <ComposeTreeTable
              ref={tableRef}
              tableConfig={{
                blockData: tableBlockData,
                rowKey: "dataId",
                columns,
                showOperationColumn: false,
              }}
              actionCallback={actionCallback}
            />
          </div>
        </div>
      )}
    </Modal>
  );
});

export default ShopListModal;
