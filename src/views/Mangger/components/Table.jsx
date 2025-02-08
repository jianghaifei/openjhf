import { Space, Table, Popconfirm, Button, message } from "antd";
import "../index.less";
import React, { useEffect, useRef, useState } from "react";
import TableAdd from "./TableAdd";
import { nodeSort, apiDelete, apiSort } from "../../../services/operation/index";
import SortSimpleDataDialog from "./sort/SortSimpleDataDialog";
import TableSelect from "./TableSelect";
const NTable = props => {
  const { apiData, onTableChange } = props;
  const addRef = useRef(null);
  const selectRef = useRef(null);
  const [data, setData] = useState([]);
  const [isShowSort, setIsShowSort] = useState(false);
  const [sortData, setSortData] = useState([]);

  useEffect(() => {
    console.log("选中节点", apiData);
    setData(apiData.apiList || []);
    setSortData(apiData.apiList || []);
  }, [apiData]);

  const deleteApi = item => {
    apiDelete({
      ...item,
      nodeUid: ""
    }).then(res => {
      if (res.code != "000") {
        return message.warning(res.msg);
      }
      message.success(res.msg);
      onTableChange && onTableChange();
    });
  };

  const handleSortData = data => {
    console.log("排序结束", data);
    apiSort({
      nodeUid: apiData.code,
      apiUidSortedList: data.map(el => el.apiUid)
    }).then(res => {
      if (res.code != "000") {
        return message.warning(res.msg);
      }
      message.success("排序成功");
      setIsShowSort(false);
      onTableChange && onTableChange();
    });
  };

  const columns = [
    {
      title: "apiName",
      dataIndex: "apiName",
      key: "apiName",
      render: (text, record) => (
        <a
          onClick={() => {
            addRef.current.open({
              title: "编辑Api",
              type: "edit",
              apiUid: record.apiUid,
              nodeUid: apiData.code,
              record: record
            });
          }}
        >
          {text}
        </a>
      )
    },
    {
      title: "apiUid",
      dataIndex: "apiUid",
      key: "apiUid"
    },
    {
      title: "Action",
      key: "action",
      render: (_, record) => (
        <Space size="middle">
          <a
            onClick={() => {
              addRef.current.open({
                title: "编辑Api",
                type: "edit",
                apiUid: record.apiUid,
                nodeUid: apiData.code,
                record: record
              });
            }}
          >
            编辑
          </a>
          <Popconfirm
            title="确认删除吗？"
            okText="确认"
            cancelText="取消"
            onConfirm={() => {
              deleteApi(record);
            }}
          >
            <a>删除</a>
          </Popconfirm>
        </Space>
      )
    }
  ];

  return (
    <>
      <div className="op_tr_top">
        <Button
          onClick={() => {
            setIsShowSort(true);
          }}
        >
          排序
        </Button>
        <Space>
          <Button
            type="primary"
            onClick={() => {
              selectRef.current.open({
                title: "新增Api",
                apiUid: "",
                nodeUid: apiData.code,
                data: data
              });
            }}
          >
            选择已存在Api新增
          </Button>
          <Button
            type="primary"
            onClick={() => {
              addRef.current.open({
                title: "新增Api",
                apiUid: "",
                nodeUid: apiData.code
              });
            }}
          >
            新增
          </Button>
        </Space>
      </div>
      <Table columns={columns} dataSource={data} />

      <TableAdd ref={addRef} apiData={apiData} onChange={onTableChange} />

      <TableSelect
        ref={selectRef}
        onChange={item => {
          addRef.current.open({
            title: "编辑Api",
            type: "edit",
            apiUid: item.apiUid,
            nodeUid: apiData.code,
            record: item
          });
        }}
      />

      <SortSimpleDataDialog
        open={isShowSort}
        title={"Api排序"}
        fieldNames={{
          value: "apiUid",
          label: "apiName"
        }}
        onOK={handleSortData}
        onCancel={() => {
          setIsShowSort(false);
        }}
        tableData={sortData || []}
      />
    </>
  );
};
export default NTable;
