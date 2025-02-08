import React, { useState } from "react";
import { Form, Input, Modal, Select, message, Alert } from "antd";
import { useParams } from "react-router-dom";
import DeveloperCallbackService from "../../../services/developer/DeveloperCallbackService";

const typeOptions = [
  {
    value: 1,
    name: "订单",
    url: "/notify/orderStatus"
  },
  {
    value: 2,
    name: "账单",
    url: "/addBillData"
  },
  {
    value: 5,
    name: "桌台",
    url: "/push/tableInfo"
  }
];

const formItemLayout = {
  labelCol: { span: 4 },
  wrapperCol: { span: 20 }
};
const CallbackEditor = props => {
  const { visible, items = [], userId, onFinished } = props;
  const { id } = useParams();
  const [form] = Form.useForm();
  const [callbackStatus, updateCallbackStatus] = useState(0);
  const [callbackSuffix, updateCallbackSuffix] = useState("");
  const [callbackPrefix, updateCallbackPrefix] = useState("http://");

  const filterCallbackStatus = () => {
    switch (callbackStatus) {
      case 1:
        return "测试中";
      case 2:
        return "确定";
      default:
        return "测试";
    }
  };
  const handleOk = () => {
    form.validateFields().then(values => {
      const { path, type } = values;
      const url = callbackPrefix + path;
      if (callbackStatus === 0) {
        updateCallbackStatus(1);
        DeveloperCallbackService.verify(url, type)
          .then(res => {
            const { code, result } = res;
            if (code !== "000") {
              updateCallbackStatus(0);
              return false;
            }
            if (result !== "000") {
              updateCallbackStatus(0);
              message.error("测试失败,请确认地址或返回信息是否正确");
              return false;
            }
            message.success("回调地址测试成功,点击确定添加回调地址");
            updateCallbackStatus(2);
          })
          .catch(() => {
            updateCallbackStatus(0);
          });
      }
      if (callbackStatus === 2) {
        DeveloperCallbackService.save({
          notifyPrefix: url,
          notifyType: type,
          merUserId: id,
          platUserId: userId
        }).then(res => {
          const { code } = res;
          if (code !== "000") return false;
          message.success("新增回调成功");
          onFinished(true);
        });
      }
    });
  };

  const getTips = (
    <>
      <div>1.当确定回调类型和回调地址后,请先测试回调地址是否有效;</div>
      <div>2.点击测试,我们将会发送验证内容示例如下: {JSON.stringify({ action: "【回调类型】 callback config" })} </div>
      <div>3.若您收到消息,请返回 {JSON.stringify({ code: "000" })} 即可配置成功.</div>
    </>
  );
  const handleSuffixOnSelected = selectedKey => {
    const typeItem = typeOptions.find(item => selectedKey === item.value);
    updateCallbackSuffix(typeItem.url);
    updateCallbackStatus(0);
  };
  const handlePrefixOnSelected = selectedKey => {
    updateCallbackPrefix(selectedKey);
    updateCallbackStatus(0);
  };
  const inputBefore = (
    <Select value={callbackPrefix} className="select-before" onSelect={handlePrefixOnSelected}>
      <Select.Option value="http://">http://</Select.Option>
      <Select.Option value="https://">https://</Select.Option>
    </Select>
  );

  return (
    <Modal
      visible={visible}
      width={650}
      getContainer={false}
      title="新增回调"
      confirmLoading={callbackStatus === 1}
      okText={filterCallbackStatus(callbackStatus)}
      onCancel={() => onFinished(false)}
      onOk={handleOk}
    >
      <Alert style={{ marginBottom: 20 }} message="提示" description={getTips} type="warning" />
      <Form {...formItemLayout} form={form}>
        <Form.Item name="type" rules={[{ required: true, message: "请选择回调类型" }]} label="回调类型">
          <Select placeholder="请选择回调类型" onSelect={handleSuffixOnSelected}>
            {typeOptions.map(item => {
              return (
                <Select.Option key={item.value} disabled={items.includes(item.value)} value={item.value}>
                  {item.name}
                </Select.Option>
              );
            })}
          </Select>
        </Form.Item>
        <Form.Item name="path" rules={[{ required: true, message: "请输入回调地址" }]} label="回调地址">
          <Input
            placeholder="请输入回调地址"
            addonBefore={inputBefore}
            addonAfter={callbackSuffix}
            onChange={() => updateCallbackStatus(0)}
          />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default React.memo(CallbackEditor);
