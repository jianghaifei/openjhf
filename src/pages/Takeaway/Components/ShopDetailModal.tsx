import { Button, Image, InputNumber, Spin, Modal, Switch } from "antd";
import { useEffect, useMemo, useRef, useState, forwardRef, useImperativeHandle } from "react";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
import { useLoaderData } from "react-router-dom";
import { IKVProps } from "@restosuite/field-core";
import { getPaymentApplyShop } from "@src/Api/Restaurant/Payment";
import BlockTitle from "@src/Components/Title";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import { useTranslation } from "react-i18next";
import { RestaurantEnum } from "@src/Locales/Constants/RestaurantEnum";
import { ReactComponent as DefaultImageSvg } from "@src/assets/Restaurant/DefaultImage.svg";
import { ReactComponent as ActiveImageSvg } from "@src/assets/Restaurant/ActiveImage.svg";
import { getLocationList } from "@src/Api/BaseServe/Location";
import { getListArea } from "@src/Api/Takeaway/StoreAndItems";
import _ from "lodash";

export type IShopDetailRef = {
  open: (params: any) => void;
};
const ShopListModal = forwardRef<IShopDetailRef, any>((props, ref) => {
  const { title, formBlock, tableBlock } = props;
  const { pageUtils } = useLoaderData() as any;
  const { t, i18n } = useTranslation(["Restaurant"]);
  const [queryForm, setQueryForm] = useState<any>({});
  const baseQueryRef = useRef<any>({});
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const [open, setOpen] = useState<boolean>(false);
  const [loading, setLoading] = useState(false);
  const queryRef = useRef<IKVProps>({
    ...baseQueryRef.current,
    page: {
      pageNo: 1,
      pageSize: 10,
    },
  });
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { shopIds } = params;
      if (Array.isArray(shopIds) && shopIds.length > 0) {
        const newObj = { ...baseQueryRef.current };
        newObj.shopIdList = shopIds || [];
        baseQueryRef.current = newObj;
      }
      setOpen(true);
    },
  }));
  const requestList = () => {
    setLoading(true);
    getLocationList({ ...queryRef.current })
      .then((res) => {
        const { data, code } = res;
        if (code === "000") {
          const newdataList = _.cloneDeep(data.list);
          const resultdataListPromises = newdataList.map(async (el: any) => {
            // 使用let声明变量，以保持作用域
            const statePromise = [];

            if (el.address && el.address.adminDivL1) {
              statePromise.push(
                getListArea({
                  countryCode: el.country,
                  languageCode: i18n.language,
                }).then((sheng) => {
                  const stateText = (sheng.data || []).filter(
                    (item: any) => item.areaCode === el.address.adminDivL1
                  )[0]?.text;
                  el.state = stateText; // 确保stateText存在后再赋值
                })
              );
            }

            if (el.address && el.address.adminDivL2) {
              statePromise.push(
                getListArea({
                  countryCode: (el.address && el.address.adminDivL1) || "",
                  languageCode: i18n.language,
                  parentAreaCode: (el.address && el.address.adminDivL1) || "",
                }).then((shi) => {
                  const stateText = (shi.data || []).filter(
                    (item: any) => item.areaCode === el.address.adminDivL2
                  )[0]?.text;
                  el.city = stateText; // 确保stateText存在后再赋值
                })
              );
            }

            // 使用Promise.all处理state和city的异步操作
            return Promise.all(statePromise).then(() => el);
          });
          Promise.all(resultdataListPromises)
            .then((resolvedList) => {
              tableRef.current?.setTableData(resolvedList);
              setLoading(false);
            })
            .catch((error) => {
              setLoading(false);
            });
          tableRef.current?.setPagination({
            current: data.page?.pageNo || 1,
            total: data.page?.total,
            pageSize: data.page?.pageSize || 10,
          });
        } else {
          setLoading(false);
        }
      })
      .catch(() => {
        setLoading(false);
      });
  };

  const actionCallback = (actionProps: IComposeTreeTableActionCallbackProps) => {
    const newObj = {
      ...baseQueryRef.current,
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
      dataIndex: "name",
      render(value: string, record: IKVProps) {
        return (
          <div className="flex items-center">
            {record?.logo ? <Image width={30} src={record.logo} /> : <DefaultImageSvg />}
            <Button type="link" className="ml-[-10px]">
              {value}
            </Button>
          </div>
        );
      },
    },
    {
      dataIndex: "dataId",
      render(value: number) {
        return <span>{value}</span>;
      },
    },
    {
      dataIndex: "isActive",
      render: (value: boolean, record: IKVProps) => {
        return <Switch checked={value} disabled></Switch>;
      },
    },
  ];

  const locationInfo = useMemo(() => {
    return (
      <div>
        <Spin spinning={loading}>
          <ComposeTreeTable
            ref={tableRef}
            tableConfig={{
              blockData: tableBlock,
              rowKey: "dataId",
              columns,
              showOperationColumn: false,
            }}
            formConfig={{
              showReset: true,
              blockData: formBlock,
            }}
            actionCallback={actionCallback}
          />
        </Spin>
      </div>
    );
  }, [tableBlock, formBlock, loading]);

  return (
    <Modal
      width="80%"
      className={`${stylesModel.customModal}`}
      open={open}
      title={title}
      footer={false}
      destroyOnClose={true}
      onCancel={() => {
        setOpen(false);
      }}
    >
      {open && locationInfo}
    </Modal>
  );
});

export default ShopListModal;
