import React, { PureComponent } from "react";
import { Form, Button, Input, message } from "antd";
import { Markup } from "interweave";
import DeveloperFormItem from "./components/DeveloperFormItem";
import DeveloperTitle from "./components/DeveloperTitle";
import DeveloperService from "../../services/developer/DeveloperService";
import "./css/Decode.less";

const { TextArea } = Input;

class DeveloperDecode extends PureComponent {
  formRef = React.createRef();

  state = {};

  componentWillUnmount() {
    this.setState = () => {};
  }

  handleSubmit = values => {
    const params = {
      text: values.text,
      secret: values.appSecret
    };
    DeveloperService.lgnAESDncode(params).then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      if (result) {
        this.setState({
          result: `<pre>${result}</pre>`
        });
      } else message.error("参数有误，解密失败！");
    });
  };

  render() {
    const { result } = this.state;

    return (
      <div className="developer-decode">
        <DeveloperTitle title="解密工具" />
        <Form ref={this.formRef} onFinish={this.handleSubmit}>
          <DeveloperFormItem label="appSecret" formName="appSecret" rules={[{ required: true, message: "请输入appSecret!" }]}>
            <Input placeholder="请输入appSecret" />
          </DeveloperFormItem>
          <DeveloperFormItem formName="text" label="requestBody密文" rules={[{ required: true, message: "请输入requestBody密文!" }]}>
            <TextArea rows={6} placeholder="请输入requestBody密文" />
          </DeveloperFormItem>
          <DeveloperFormItem type="other">
            <Button type="primary" htmlType="submit">
              解密
            </Button>
          </DeveloperFormItem>
        </Form>
        <DeveloperFormItem type="other" label="解密结果">
          <Markup className="common-mark-up sign-check-code" content={result} />
        </DeveloperFormItem>
      </div>
    );
  }
}

export default DeveloperDecode;
