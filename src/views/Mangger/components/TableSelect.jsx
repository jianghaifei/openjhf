import { Table, Input, Modal, Button, Form, Popconfirm, message, Space } from "antd";
import React, { forwardRef, useEffect, useRef, useState, useImperativeHandle } from "react";
import { UserOutlined, MoreOutlined } from "@ant-design/icons";
import "./index.less";
import _ from "lodash";
import SortSimpleDataDialog from "./sort/SortSimpleDataDialog";
import { apiQuery, apiSave, apiList } from "../../../services/operation/index";

const AddModel = forwardRef((props, ref) => {
  const [form] = Form.useForm();
  const { onChange } = props;
  const [open, setOpen] = useState(false);
  const [data, setData] = useState([]);
  const [selectedRows, setSelectedRows] = useState([]);
  const [selectedRowKeys, setSelectedRowKeys] = useState([]);
  useImperativeHandle(ref, () => ({
    open(params = {}) {
      queryApiList();
      setOpen(true);
      setSelectedRowKeys([]);
      setSelectedRows([])
      if (params.type == "edit") {
        queryAppiFn(params.apiUid);
      }
    },
    destroy(params = {}) {
      setOpen(false);
    }
  }));

  const queryApiList = () => {
    apiList({}).then(res => {
      if (res.code != "000") {
        return message.warning(res.msg);
      }
      setData(res.data);
    });
  };

  const queryAppiFn = apiUid => {
    apiQuery({
      apiUid
    }).then(res => {
      if (res.code != "000") {
        return message.warning(res.msg);
      }
      Object.keys(res.data).forEach(key => {
        form.setFieldValue(key, res.data[key]);
      });
    });
  };

  const handleCancel = () => {
    setOpen(false);
  };

  const subMitFn = async () => {
    if (selectedRows.length == 0) {
      return message.warning("请先选择Api!");
    }

    onChange && onChange(selectedRows[0]);
    setOpen(false);
  };

  const columns = [
    {
      title: "apiName",
      dataIndex: "apiName",
      key: "apiName",
      render: text => <a>{text}</a>
    },
    {
      title: "apiUid",
      dataIndex: "apiUid",
      key: "apiUid"
    },
    {
      title: "status",
      dataIndex: "status",
      key: "status"
    }
  ];

  const rowSelection = {
    selectedRowKeys: selectedRowKeys,
    onChange: (selectedRowKeys, selectedRows) => {
      setSelectedRowKeys(selectedRowKeys);
      // console.log(`selectedRowKeys: ${selectedRowKeys}`, "selectedRows: ", selectedRows);
      setSelectedRows(selectedRows);
    },
    getCheckboxProps: record => ({
      // disabled: record.name === "Disabled User",
      // Column configuration not to be checked
      name: record.name
    })
  };

  return (
    <>
      <Modal
        title={"选择Api列表"}
        open={open}
        onCancel={() => {
          handleCancel();
        }}
        width={"90%"}
        footer={[
          <Button onClick={handleCancel}>取消</Button>,
          <Button type="primary" onClick={subMitFn}>
            下一步
          </Button>
        ]}
      >
        <Table
          columns={columns}
          dataSource={data}
          rowKey={"apiUid"}
          rowSelection={{
            type: "radio",
            ...rowSelection
          }}
        />
      </Modal>
    </>
  );
});

export default AddModel;
