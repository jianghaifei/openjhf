import React, { PureComponent } from "react";
import * as utility from "utility";
import { Form, Button, Col, Input, message, Modal, Row, Statistic } from "antd";
import { getCountdown, getVerifyTelephoneRule, verifyTelephone } from "../../../utils/utils";
import AuthService from "../../../services/auth/AuthService";
import PasswordLoginService from "../../../services/auth/PasswordLoginService";
import ImgCodeModal from "../../image-code-dialog/ImageCodeDialog";
import TelephoneAreaCode from "../../../components/general/TelephoneAreaCode";

const { Countdown } = Statistic;
const formItemLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 18 }
};

class ResetPhoneModal extends PureComponent {
  formRef = React.createRef();

  state = {
    btnTxt: "获取验证码",
    codeBtnDisabled: false,
    imgCodeVisible: false,
    phoneAreaCode: null
  };

  // 点击获取验证码
  handleSendMsgCode = () => {
    const { phoneAreaCode } = this.state;
    const { getFieldValue, setFieldsValue, validateFields } = this.formRef.current;
    const loginPwd = getFieldValue("loginPwd");
    if (loginPwd) {
      const phoneNum = getFieldValue("phoneNum");
      if (!verifyTelephone(phoneNum, phoneAreaCode)) {
        setFieldsValue({
          phoneNum
        });
        validateFields(["phoneNum"]);
        return;
      }
      const params = {
        loginName: sessionStorage.getItem("loginName"),
        loginPwd: utility.md5(loginPwd)
      };
      PasswordLoginService.checkPassword(params).then(res => {
        if (!res) {
          message.error("连接服务器失败");
          return;
        }
        // 密码验证成功
        if (res.code === "000") {
          this.setState({ imgCodeVisible: true });
        } else {
          setFieldsValue({
            loginPwd: ""
          });
          validateFields(["loginPwd"]);
        }
      });
    } else {
      setFieldsValue({
        loginPwd: ""
      });
      validateFields(["loginPwd"]);
    }
  };

  // 验证码60s倒计时结束
  onFinish = () => {
    this.setState({
      btnTxt: "获取验证码",
      codeBtnDisabled: false
    });
  };

  // 滑块匹配成功
  handleImgCodeMatch = data => {
    const { phoneAreaCode } = this.state;
    const phoneNum = this.formRef.current.getFieldValue("phoneNum");
    const params = { phoneAreaCode, phoneNum, type: 4, imgCode: data };
    AuthService.sendVerificationCode(params).then(res => {
      if (res.code !== "000") return false;
      message.success("验证码发送成功");
      this.setState({
        btnTxt: <Countdown value={getCountdown()} format="s 秒" onFinish={this.onFinish} />,
        imgCodeVisible: false,
        codeBtnDisabled: true
      });
    });
  };

  handleImgCodeCancel = () => {
    this.setState({ imgCodeVisible: false });
  };

  onOk = () => {
    const { onCreate } = this.props;
    const { validateFields, resetFields } = this.formRef.current;
    validateFields().then(values => {
      resetFields();
      onCreate(values);
    });
  };

  handleOnCancel = () => {
    const { onCancel } = this.props;
    this.formRef.current.resetFields();
    onCancel();
  };

  getAreaCode = value => {
    this.formRef.current.setFieldsValue({
      phoneNum: ""
    });
    this.setState({ phoneAreaCode: value });
  };

  render() {
    const { visible } = this.props;
    const { btnTxt, codeBtnDisabled, imgCodeVisible, phoneAreaCode } = this.state;

    return (
      <Modal
        getContainer={false}
        visible={visible}
        title="修改手机号 "
        okText="确定"
        cancelText="取消"
        onCancel={this.handleOnCancel}
        onOk={this.onOk}
        className="reset-phone-modal"
      >
        <Form ref={this.formRef} {...formItemLayout}>
          <Form.Item label="密码" name="loginPwd" rules={[{ required: true, message: "请输入原密码!" }]}>
            <Input type="password" placeholder="请输入原密码" />
          </Form.Item>
          <Form.Item
            label="手机号"
            name="phoneNum"
            rules={[
              { required: true, message: "请输入手机号!" },
              {
                pattern: getVerifyTelephoneRule(phoneAreaCode),
                message: "格式不正确!"
              }
            ]}
          >
            <Input
              className="telephone-input phone-item"
              addonBefore={<TelephoneAreaCode onChange={this.getAreaCode} />}
              placeholder="请输入手机号"
            />
          </Form.Item>
          <Form.Item
            label="验证码"
            name="identifyCode"
            rules={[
              {
                required: true,
                message: "请输入验证码!"
              }
            ]}
          >
            <Row>
              <Col span={12}>
                <Input placeholder="请输入验证码" />
              </Col>
              <Col span={10} offset={2} className="t-right">
                <Button className="code-button" disabled={codeBtnDisabled} onClick={this.handleSendMsgCode}>
                  {btnTxt}
                </Button>
              </Col>
            </Row>
          </Form.Item>
        </Form>
        <ImgCodeModal visible={imgCodeVisible} onMatch={this.handleImgCodeMatch} onCancel={this.handleImgCodeCancel} />
      </Modal>
    );
  }
}

export default ResetPhoneModal;
