import React, { PureComponent } from "react";
import { ExclamationCircleFilled } from "@ant-design/icons";
import { Form, Alert, Button, Col, Input, message, Row } from "antd";
import Highlight from "react-highlight";
import DeveloperFormItem from "./components/DeveloperFormItem";
import DeveloperTitle from "./components/DeveloperTitle";
import DeveloperService from "../../services/developer/DeveloperService";
import "./css/Signature.less";
import "highlight.js/styles/zenburn.css";

const { TextArea } = Input;

class DeveloperSignature extends PureComponent {
  formRef = React.createRef();

  state = {};

  componentWillUnmount() {
    this.setState = () => {};
  }

  drawSteps = () => {
    const { steps } = this.state;
    return steps.map((step, index) => {
      return (
        <div key={index} className="step">
          <Row className="row-desc">
            <Col span={2} offset={1}>
              第 {index + 1}{" "}
            </Col>
            <Col span={14}>{step.desc}</Col>
          </Row>
          <Row className="row-param">
            <Col span={2} offset={1}>
              输入
            </Col>
            <Col>
              <Highlight className="JSON">{step.input}</Highlight>
            </Col>
          </Row>
          <Row className="row-param">
            <Col span={2} offset={1}>
              输出
            </Col>
            <Col>
              <Highlight className="JSON">{step.output}</Highlight>
            </Col>
          </Row>
        </div>
      );
    });
  };

  // 提交
  handleSignSubmit = values => {
    const { appKey, timestamp, version, json, secret } = values;
    const params = {
      appKey,
      secret,
      timestamp,
      version,
      json
    };
    DeveloperService.lgnSign(params).then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      if (result) {
        const { steps } = result;
        if (steps) this.setState({ steps });
      } else message.error("参数有误，生成签名失败！");
    });
  };

  renderAlert = () => {
    return (
      <Alert
        message="注意事项"
        description={
          <div>
            <p>1. 请求的header中的参数不参与签名；</p>
            <p>
              2.
              为了防止API调用过程中被黑客恶意篡改，调用任何一个API都需要携带签名，开放平台服务端会根据请求参数，对签名进行验证，签名不合法的请求将会被拒绝；
            </p>
          </div>
        }
        type="warning"
        showIcon
        icon={<ExclamationCircleFilled />}
      />
    );
  };

  render() {
    const { steps } = this.state;
    return (
      <div className="developer-signature">
        <DeveloperTitle title="签名工具" />
        {this.renderAlert()}
        <Form className="mt-24" onFinish={this.handleSignSubmit}>
          <div className="form-title">开发者密钥</div>
          <DeveloperFormItem label="appSecret" formName="secret" rules={[{ required: true, message: "请输入appSecret!" }]}>
            <Input placeholder="请输入appSecret" />
          </DeveloperFormItem>
          <div className="form-title">公共参数</div>
          <DeveloperFormItem label="appKey" formName="appKey" rules={[{ required: true, message: "请输入appKey!" }]}>
            <Input placeholder="请输入appKey" />
          </DeveloperFormItem>
          <DeveloperFormItem label="timestamp" formName="timestamp" rules={[{ required: true, message: "请输入timestamp!" }]}>
            <Input placeholder="请输入timestamp" />
          </DeveloperFormItem>

          <DeveloperFormItem label="version" formName="version" rules={[{ required: true, message: "请输入version!" }]}>
            <Input placeholder="请输入version" />
          </DeveloperFormItem>
          <div className="form-title">业务参数</div>
          <DeveloperFormItem formName="json" rules={[{ required: true, message: "请输入业务参数!" }]}>
            <TextArea rows={6} placeholder="请输入业务参数JSON" />
          </DeveloperFormItem>
          <DeveloperFormItem type="other">
            <Button type="primary" htmlType="submit">
              生成签名
            </Button>
          </DeveloperFormItem>
        </Form>
        {steps ? this.drawSteps() : null}
      </div>
    );
  }
}

export default DeveloperSignature;
