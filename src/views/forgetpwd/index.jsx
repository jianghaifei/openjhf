import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Form, Button, Col, Input, message, Row, Statistic, Steps } from "antd";
import * as utility from "utility";
import PasswordLoginService from "../../services/auth/PasswordLoginService";
import AuthService from "../../services/auth/AuthService";
import { getCountdown, getVerifyTelephoneRule, verifyTelephone } from "../../utils/utils";
import ImgCodeModal from "../../containers/image-code-dialog/ImageCodeDialog";
import { changeLoginDialogVisible } from "../../store/actions/Common";
import TelephoneAreaCode from "../../components/general/TelephoneAreaCode";
import "./index.less";

const { Step } = Steps;
const { Countdown } = Statistic;
const formItemLayout = {
  labelCol: { span: 4, offset: 1 },
  wrapperCol: { span: 18 }
};

class ForgetPassword extends PureComponent {
  // 第一步的form实例
  formRef = React.createRef();

  // 第二步的form实例
  formRef1 = React.createRef();

  state = {
    activeStep: 0,
    btnTxt: "获取验证码",
    codeBtnDisabled: false,
    imgCodeVisible: false,
    phoneAreaCode: null
  };

  // 点击获取验证码
  handleSendMsgCode = () => {
    const { phoneAreaCode } = this.state;
    const phoneNum = this.formRef.current.getFieldValue("phoneNum");
    if (verifyTelephone(phoneNum, phoneAreaCode)) {
      this.setState({ imgCodeVisible: true });
    } else {
      message.error("请输入有效手机号码");
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
    const params = { phoneAreaCode, phoneNum, type: 3, imgCode: data };
    AuthService.sendVerificationCode(params).then(res => {
      if (res.code !== "000") return false;
      message.success("验证码发送成功");
      this.setState({
        btnTxt: <Countdown value={getCountdown()} format="s 秒" onFinish={this.onFinish} />,
        codeBtnDisabled: true,
        imgCodeVisible: false
      });
    });
  };

  // 返回登录
  handleToLogin = e => {
    e.preventDefault();
    this.props.changeLoginDialogVisible(true);
    this.props.history.push("/");
  };

  // 点击“找回密码”
  handleToNextStep = values => {
    PasswordLoginService.checkPhoneCode(values).then(res => {
      const { code, result = {} } = res;
      if (code !== "000") return false;
      this.setState({
        activeStep: 1,
        loginId: result.id
      });
    });
  };

  // 确认密码框校验
  compareToFirstPassword = (rule, value, callback) => {
    if (value && value !== this.formRef1.current.getFieldValue("loginPwd")) {
      callback("输入的两个密码不一致");
    } else {
      callback();
    }
  };

  // 点击 确定POST
  handleSubmit = values => {
    const params = {
      loginId: this.state.loginId,
      loginPwd: utility.md5(values.loginPwd)
    };
    PasswordLoginService.resetLoginPwd(params).then(res => {
      if (res.code !== "000") return false;
      message.success("重置密码成功，请登录!");
      this.props.history.push("/");
      this.props.changeLoginDialogVisible(true);
    });
  };

  handleImgCodeCancel = () => {
    this.setState({ imgCodeVisible: false });
  };

  getAreaCode = value => {
    this.formRef.current.setFieldsValue({
      phoneNum: ""
    });
    this.setState({ phoneAreaCode: value });
  };

  render() {
    const { codeBtnDisabled, btnTxt, activeStep, imgCodeVisible, phoneAreaCode } = this.state;
    return (
      <div className="forget-wrap">
        <div className="top" />
        <div className="bottom" />
        <div className="content">
          <div style={{ width: "380px", margin: " 20px auto" }}>
            <Steps size="small" current={activeStep} style={{ marginBottom: " 40px" }} labelPlacement="vertical">
              <Step title="填写手机号" />
              <Step title="重置密码" />
            </Steps>
            {activeStep === 0 ? (
              <Form {...formItemLayout} ref={this.formRef} onFinish={this.handleToNextStep}>
                <Form.Item
                  name="phoneNum"
                  label={<span className="t-left">手机号&nbsp;:</span>}
                  colon={false}
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
                  name="identifyCode"
                  label={<span className="t-left">验证码&nbsp;:</span>}
                  colon={false}
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
                <Form.Item label=" " colon={false}>
                  <Button type="primary" htmlType="submit" className="forget-form-button">
                    找回密码
                  </Button>
                  <Button type="link" onClick={this.handleToLogin}>
                    返回登录
                  </Button>
                </Form.Item>
              </Form>
            ) : (
              <Form {...formItemLayout} ref={this.formRef1} onFinish={this.handleSubmit}>
                <Form.Item
                  name="loginPwd"
                  label="密码"
                  rules={[
                    {
                      required: true,
                      message: "请输入密码"
                    },
                    {
                      pattern: /^(?![^0-9]+$)(?![^a-zA-Z]+$)(?![^_]+$)[0-9A-Za-z_]{8,12}$/,
                      message: "请输入8-12位英文字母数字和下划线组合!"
                    }
                  ]}
                >
                  <Input type="password" placeholder="请输入8-12位英文字母数字和下划线组合" />
                </Form.Item>
                <Form.Item
                  name="confirmLoginPwd"
                  label="确认密码"
                  rules={[
                    {
                      required: true,
                      message: "再次输入密码!"
                    },
                    {
                      validator: this.compareToFirstPassword
                    }
                  ]}
                >
                  <Input type="password" placeholder="再次输入密码" />
                </Form.Item>
                <Form.Item label=" " colon={false}>
                  <Button type="primary" htmlType="submit" className="forget-form-button">
                    确 定
                  </Button>
                  <Button type="link" onClick={this.handleToLogin}>
                    返回登录
                  </Button>
                </Form.Item>
              </Form>
            )}
            <ImgCodeModal visible={imgCodeVisible} onMatch={this.handleImgCodeMatch} onCancel={this.handleImgCodeCancel} />
          </div>
        </div>
      </div>
    );
  }
}

const mapDispatchToProps = {
  changeLoginDialogVisible
};

export default connect(
  null,
  mapDispatchToProps
)(ForgetPassword);
