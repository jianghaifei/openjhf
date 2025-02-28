import { Button } from "antd";
import { IKVProps } from "@restosuite/field-core";
import { ILoaderData } from "@src/Router/GenerateRoutes";
import { useLoaderData, useSearchParams } from "react-router-dom";
import { useMemo, useRef, useState } from "react";
import { useTranslation } from "react-i18next";
import PageContainer from "@src/Components/Layouts/PageContainer";
import useCustomNavigate from "@src/Hooks/useCustomNavigate";
import {
  ComposeTreeTable,
  IComposeTreeTableActionCallbackProps,
  IComposeTreeTableRef,
} from "@restosuite/field-components";
import { ITable } from "@src/Components/Table/ITable";
import { useStore } from "@src/Store";
import dayjs from "dayjs";
import { queryPublishHistory, queryPublishMenuList } from "@src/Api/Takeaway/StoreAndItems";
import PageMetaUtils from "@src/Utils/PageMetaUtils";
import { asyncGetPageMetaUtils } from "@src/Utils/PageMetaHelper";
import { PagesName } from "@src/PageMeta/PageModulesMeta";
import ShopDetailModal, { IShopDetailRef } from "../Components/ShopDetailModal";
import RecordDetail, { IRecordDetailRef } from "./Components/RecordDetail";
import PublishResultDetail, { IPublishResultDetailRef } from "./Components/PublishResultDetail";
import StatusItem from "./Components/RecordStatusItem";

const View = () => {
  const [searchParams] = useSearchParams();
  const [typeId] = useState(searchParams.get("type"));
  const [typeLabel] = useState(searchParams.get("label"));
  const [shopId] = useState(searchParams.get("shopId"));
  const [targetOrgType] = useState(searchParams.get("targetOrgType"));
  const { dispatchNavigate } = useCustomNavigate();
  const { pageUtils } = useLoaderData() as ILoaderData;
  const [linkPageUtils, setLinkPageUtils] = useState<PageMetaUtils>();
  const tableRef = useRef<IComposeTreeTableRef>(null);
  const { t, i18n } = useTranslation(["Common"]);
  const pageContainerRef = useRef<any>(null);
  const { loginStore } = useStore();
  const queryRef = useRef<IKVProps>({});
  const [queryParams, setQueryParams] = useState<IKVProps>({});
  const shopDetailRef = useRef<IShopDetailRef>(null);
  const recordDetailRef = useRef<IRecordDetailRef>(null);
  const detailResRef = useRef<IPublishResultDetailRef>(null);
  const tableBlockData = useMemo(() => {
    const blockData = pageUtils.getBlockData("TableList");
    if (blockData?.fields && blockData.fields.length > 0) {
      blockData.tableConfig = {
        type: "table",
        operationColumnConfig: {},
        columnConfig: blockData?.fields.map((item: any) => ({
          id: item.fieldId,
          minWidth: 150,
        })),
      };
    }
    return blockData;
  }, [pageUtils]);
  const statusOptions = useMemo(() => {
    const blockData: any = tableBlockData || {};
    const options = blockData.fields?.find((item: any) => item.fieldId === "status")?.data
      ?.dataSource;
    return options;
  }, [tableBlockData]);
  const locationTable = useMemo(() => {
    return linkPageUtils?.getBlockData("locationTable");
  }, [linkPageUtils]);
  const locationSearchForm = useMemo(() => {
    return linkPageUtils?.getBlockData("locationSearchForm");
  }, [linkPageUtils]);

  const tableColumns: ITable["columns"] = [
    {
      dataIndex: "status",
      render(value: string, record: any) {
        const label = statusOptions.find((child: any) => child.value === value)?.label || value;
        return <StatusItem label={label} value={record.status} />;
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
      dataIndex: "locationIds",
      render(value: string[], record: any) {
        return (
          <Button
            type="link"
            onClick={() => {
              asyncGetPageMetaUtils("Discounts").then((res) => {
                setLinkPageUtils(res);
              });
              shopDetailRef.current?.open({
                shopIds: record.locationIds || [],
              });
            }}
          >
            {value ? value.length : 0}
          </Button>
        );
      },
    },
  ];
  // 获取外卖菜单列表
  const getMenuList = () => {
    queryPublishMenuList({
      shopId: shopId,
    })
      .then((res: any) => {
        const { code, data = {} } = res;
        if (code === "000") {
          const list = data.menus || [];
          tableRef.current?.formMethods?.setFieldDataSource(
            "publishMenuName",
            list.map((o: any) => ({
              label: o.menuName,
              value: o.menuId,
            }))
          );
        }
      })
      .catch((err) => {
        tableRef.current?.formMethods?.setFieldDataSource("publishMenuName", []);
      });
  };
  const actionCallback = (actionProps: IComposeTreeTableActionCallbackProps) => {
    if (actionProps.formData?.publishMenuName) {
      actionProps.formData.menuId = actionProps.formData?.publishMenuName;
      delete actionProps.formData?.publishMenuName;
    }
    const actionParams: any = {
      page: {
        pageNo: actionProps.pageNo,
        pageSize: actionProps.pageSize,
      },
      filter: {
        ...actionProps.formData,
        platform: typeId,
      },
    };
    if (actionParams.filter.publishDate && actionParams.filter.publishDate.length === 2) {
      actionParams.filter.startDateFrom = dayjs(actionParams.filter.publishDate[0])
        .startOf("day")
        .format();
      actionParams.filter.startDateTo = dayjs(actionParams.filter.publishDate[1])
        .endOf("day")
        .format();
    }
    queryRef.current = actionParams;
    setQueryParams(queryRef.current);
    queryPublishHistory(queryRef.current).then((res) => {
      const { code, data } = res;
      if (code === "000") {
        const { histories, page } = data;
        tableRef.current?.setTableData(
          (histories || []).map((item: any) => {
            return {
              ...item,
            };
          })
        );
        tableRef.current?.setPagination({
          current: data.page?.pageNo || 1,
          total: data.page?.total,
          pageSize: data.page?.pageSize,
        });
      }
    });
  };
  return (
    <PageContainer
      title={`${t("product.btnPublishRecord", {
        ns: "Takeaway",
      })}[${typeLabel}]`}
      ref={pageContainerRef}
    >
      <div className="pl-[20px] pr-[20px]">
        <div className={`w-full`}>
          {typeId && (
            <ComposeTreeTable
              ref={tableRef}
              layout="Horizontal"
              formConfig={{
                blockData: pageUtils.getBlockData("QueryForm"),
                extraProps: {
                  formMounted() {
                    getMenuList();
                  },
                },
                showReset: true,
                bottomSlot: <div className="flex justify-between mb-[10px]"></div>,
              }}
              tableConfig={{
                blockData: tableBlockData as any,
                columns: tableColumns,
                rowKey: "itemId",
                showOperationColumn: true,
                pureWidth: pageContainerRef?.current
                  ? pageContainerRef?.current?.getContentWidth() + 100
                  : 0,
                operationColumnProps: {
                  outsideBtnCount: 1,
                  width: 100,
                  extraButtonRender: (record) => {
                    return [
                      <div>
                        <Button
                          size="small"
                          type="link"
                          onClick={() => {
                            recordDetailRef.current?.open({
                              publishId: record.publishId,
                            });
                          }}
                        >
                          {t("SettlementAccount.Details", { ns: "Financial" })}
                        </Button>
                      </div>,
                    ];
                  },
                },
              }}
              actionCallback={actionCallback}
            />
          )}
        </div>
        <ShopDetailModal
          title={t("payConfig.label_store_details", { ns: "Financial" })}
          formBlock={locationSearchForm}
          tableBlock={locationTable}
          ref={shopDetailRef}
        />
        <RecordDetail
          title={`${t("takeaway.titlePublishDetail", {
            ns: "Takeaway",
          })}[${typeLabel}]`}
          ref={recordDetailRef}
          openPublish={(evt: string) => {
            detailResRef.current?.open({ publishDetailId: evt });
          }}
        />
        <PublishResultDetail
          title={t("takeaway.pushDetailTiTle", { ns: "Takeaway" })}
          ref={detailResRef}
        />
      </div>
    </PageContainer>
  );
};

export default View;
