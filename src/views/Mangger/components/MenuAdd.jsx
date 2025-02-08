import { Tree, Input, Modal, Button, Form, Select, message } from "antd";
import React, { forwardRef, useEffect, useRef, useState, useImperativeHandle } from "react";
import { UserOutlined, MoreOutlined } from "@ant-design/icons";
import "./index.less";
import _ from "lodash";
import SortSimpleDataDialog from "./sort/SortSimpleDataDialog";
import { nodeSave, nodeSort } from "../../../services/operation/index";

const AddModel = forwardRef((props, ref) => {
  const [form] = Form.useForm();
  const [info, setInfo] = useState({});
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  useImperativeHandle(ref, () => ({
    open(params = {}) {
      form.resetFields();
      setInfo(params);
      setOpen(true);
      if (params.type == "edit") {
        form.setFieldValue("nodeName", params.data.name);
      }
    },
    destroy(params = {}) {
      setOpen(false);
    }
  }));

  const handleCancel = () => {
    setOpen(false);
  };

  const subMitFn = () => {
    form.validateFields();
    const value = form.getFieldValue();
    const params = {
      ...value,
      parentUid: info.type == "add" ? info.data && info.data.code : "",
      nodeUid: info.type == "edit" ? info.data && info.data.code : ""
    };
    console.log("hhhhh", value);
    setLoading(true);
    nodeSave(params).then(res => {
      setLoading(false);
      if (res.code != "000") {
        return message.warning(res.msg);
      }
      setOpen(false);
      props.onChange && props.onChange();
      message.success(res.msg);
    });
  };

  return (
    <>
      <Modal
        title={info.title}
        open={open}
        onCancel={() => {
          handleCancel();
        }}
        width={info.width || 800}
        footer={[
          <Button onClick={handleCancel}>取消</Button>,
          <Button type="primary" onClick={subMitFn} loading={loading}>
            确认
          </Button>
        ]}
      >
        <Form
          form={form}
          name="basic"
          labelCol={{
            span: 5
          }}
          wrapperCol={{
            span: 16
          }}
          autoComplete="off"
        >
          <Form.Item
            label="目录名称"
            name="nodeName"
            rules={[
              {
                required: true,
                message: "请输入目录名称!"
              }
            ]}
          >
            <Input />
          </Form.Item>
        </Form>
      </Modal>
    </>
  );
});

export default AddModel;
