import React from "react";

import { Form, Input, Modal } from "antd";

const ResetPwdModal = props => {
  const { visible, onCancel, onCreate } = props;
  const [form] = Form.useForm();
  const formItemLayout = {
    labelCol: { span: 6 },
    wrapperCol: { span: 18 }
  };

  const validateNewPassword = (rule, value, callback) => {
    if (value && value === form.getFieldValue("oldPwd")) {
      callback("新密码与原密码相同");
    } else {
      callback();
    }
  };

  const validateConfirmNewPwd = (rule, value, callback) => {
    if (value && value !== form.getFieldValue("newPwd")) {
      callback("输入的两个密码不一致");
    } else {
      callback();
    }
  };
  const onOk = () => {
    form.validateFields().then(values => onCreate(values));
  };
  return (
    <Modal visible={visible} getContainer={false} title="密码重置 " okText="确定" cancelText="取消" onCancel={onCancel} onOk={onOk}>
      <Form form={form} {...formItemLayout}>
        <Form.Item
          name="oldPwd"
          label="原密码"
          rules={[
            {
              required: true,
              message: "请输入原密码!"
            }
          ]}
        >
          <Input type="password" placeholder="请输入原密码" />
        </Form.Item>
        <Form.Item
          label="新密码"
          name="newPwd"
          rules={[
            {
              required: true,
              message: "请输入6-12位英文字母和数字的组合!"
            },
            {
              validator: validateNewPassword
            },
            {
              pattern: /^(?![^0-9]+$)(?![^a-zA-Z]+$)(?![^_]+$)[0-9A-Za-z_]{8,12}$/,
              message: "请输入8-12位英文字母数字和下划线组合!"
            }
          ]}
        >
          <Input type="password" placeholder="请输入6-12位英文字母和数字的组合" />
        </Form.Item>
        <Form.Item
          label="确认密码"
          name="confirmNewPwd"
          rules={[
            {
              required: true,
              message: "再次输入新密码!"
            },
            { validator: validateConfirmNewPwd }
          ]}
        >
          <Input type="password" placeholder="再次输入新密码" />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default React.memo(ResetPwdModal);
