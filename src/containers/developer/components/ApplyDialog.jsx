import React from "react";
import { Form, Input, Modal } from "antd";

const ApplyDialog = props => {
  const { visible, onOk, onCancel } = props;
  const [form] = Form.useForm();

  const formItemLayout = {
    labelCol: { span: 4 },
    wrapperCol: { span: 20 }
  };
  const groupIdRules = [{ required: true, message: "请输入集团ID" }];

  const handleOk = () => {
    form.validateFields().then(values => {
      onOk(values.groupId);
    });
  };

  const handleCancel = () => {
    form.resetFields();
    onCancel();
  };
  return (
    <Modal
      visible={visible}
      getContainer={false}
      title="申请集团授权"
      okText="确定"
      cancelText="取消"
      onCancel={handleCancel}
      onOk={handleOk}
    >
      <Form {...formItemLayout} form={form}>
        <Form.Item name="groupId" rules={groupIdRules} label="集团ID">
          <Input placeholder="请输入集团ID" />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default React.memo(ApplyDialog);
