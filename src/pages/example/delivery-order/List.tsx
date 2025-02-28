
import { useState, useRef } from 'react';
import { useLoaderData } from "react-router-dom";
import BoCommon from "@restosuite/bo-common";
const {fieldComponents, BoPageContainer}  = BoCommon;
const { ComposeTreeTable } = fieldComponents;

// 列表
const List = () => {
  /* state */
  const [selectedRows, setSelectedRows] = useState<any[]>([]); // 选中行
  const [queryParams, setQueryParams] = useState<any>(); // 查询当前列表数据，所需参数
  
  /* hooks && ref */
  const listRef = useRef<any>(null);

  /* variable  */
  //页面元数据
  const { pageUtils } = useLoaderData() as any;
  const searchFormMeta = pageUtils.getBlockData("searchForm");
  const tableMeta = pageUtils.getBlockData("table");

  /* util */
  const setDefaultValue = () => {
  }

  const setDefaultProps = () => {
  }

  // 加载列表数据
  const loadListData = (params: any) => {
    listRef.current?.setTableData([]);
    listRef.current?.setPagination({
      current: 1,
      pageNo: 1,
      pageSize: 20,
      total: 0,
    });
    setQueryParams(params);
  };

  /* handle */
  const handleFormMounted = () => {
    setDefaultValue();
    setDefaultProps();
  }

  const handleFormReset = () => {
    setDefaultValue();
    setSelectedRows([]);
  }

  // 树表组件行为处理
  const handleListAction = (
    actionProps: any
  ) => {
    loadListData(actionProps);
    setSelectedRows([]);
  };


  return (
    <BoPageContainer
      title='发货单列表'
    >
      <ComposeTreeTable
        ref={listRef}
        actionCallback={handleListAction}
        formConfig={{
          blockData: searchFormMeta,
          showReset: true,
          resetCallback: () => {
            handleFormReset();
          },
          extraProps: {
            formMounted: handleFormMounted
          }
        }}
        tableConfig={{
          rowKey: "id",
          blockData: tableMeta,
          operationColumnProps: {
            width: 120,
            outsideBtnCount: 2,
          },
          extraProps: {
            rowSelection: {
              type: "checkbox",
              selectedRowKeys: selectedRows.map((row: any) => row.id),
              onChange: (selectedRowKeys: any, selectedRows: any[]) => {
                setSelectedRows(selectedRows);
              },
            },
          },
        }}
      ></ComposeTreeTable>
    </BoPageContainer>
  );
};

export default List;
