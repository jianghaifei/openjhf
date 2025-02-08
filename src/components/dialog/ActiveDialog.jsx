import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Button, Form, Input, message, Modal, Statistic } from "antd";
import { getCountdown, verifyTelephone } from "../../utils/utils";
import {
  changeLoginDialogVisible,
  changeRegisterDialogVisible,
  setUserinfo,
  protocolConfirm,
  changeActiveDialogVisible
} from "../../store/actions/Common";
import AuthService from "../../services/auth/AuthService";
import "./css/RegisterDialog.less";
import { CheckCircleOutlined, ExclamationCircleOutlined } from "@ant-design/icons";
import { passwordInit, activeSendmail } from "../../services/auth/authNew";

const { Countdown } = Statistic;

class ActiveDialog extends PureComponent {
  formRef = React.createRef();

  state = {
    isLoading: false,
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
  countdownFinish = () => {
    this.setState({
      btnTxt: "获取验证码",
      codeBtnDisabled: false
    });
  };

  // 滑块匹配成功
  handleImgCodeMatch = data => {
    const { phoneAreaCode } = this.state;
    const { registerDialogVisible } = this.props;
    if (!registerDialogVisible) return false;
    const phoneNum = this.formRef.current.getFieldValue("phoneNum");
    const params = { phoneAreaCode, phoneNum, type: 2, imgCode: data };
    AuthService.sendVerificationCode(params).then(res => {
      if (res.code !== "000") return false;
      message.success("验证码发送成功");
      this.setState({
        btnTxt: <Countdown value={getCountdown()} format="ss 秒" onFinish={this.countdownFinish} />,
        codeBtnDisabled: true,
        imgCodeVisible: false
      });
    });
  };

  // 确认密码框校验
  compareToFirstPassword = (rule, value, callback) => {
    if (value && value !== this.formRef.current.getFieldValue("loginPwd")) {
      callback("输入的两个密码不一致");
    } else {
      callback();
    }
  };

  // 点击注册
  handleSubmit = values => {
    const { loginPwd } = values;
    this.setState({ isLoading: true });
    passwordInit({
      password: loginPwd
    })
      .then(res => {
        console.log("dddd", res);
        this.setState({ isLoading: false });
        if (res.code !== "000") return;
        message.success("密码初始化成功!");
        this.formRef.current.resetFields();
        this.props.changeActiveDialogVisible(3);
      })
      .finally(() => {
        this.setState({ isLoading: false });
      });
  };

  // 使用已有账号登录
  handleToLogin = () => {
    this.props.changeRegisterDialogVisible(false);
  };

  retransmission = () => {
    const params = new URLSearchParams(location.search);

    // 获取 loginEmail 和 activeCode 的值
    const loginEmail = params.get("loginEmail");

    if (!loginEmail) {
      return message.warning("没有邮箱");
    }

    activeSendmail({ loginEmail }).then(res => {
      if (res.code != "000") return;
      message.success("邮件发送成功!");
      this.props.changeActiveDialogVisible(0);
    });
  };

  handleCancel = () => {
    this.props.changeActiveDialogVisible(0);
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

  // 去登录
  gologin = () => {
    this.props.changeActiveDialogVisible(0);
    this.props.changeLoginDialogVisible(true);
  };

  render() {
    const { activeDialogVisible } = this.props;
    const { isLoading, codeBtnDisabled, btnTxt, imgCodeVisible, phoneAreaCode } = this.state;
    return (
      <>
        <Modal
          className="register-modal"
          getContainer={false}
          visible={activeDialogVisible > 0}
          onCancel={this.handleCancel}
          width="500px"
          footer={null}
        >
          <div className="register-wrap">
            <div className="register-form">
              <div className="titleact">RESTO 开发者</div>
              {/* 1 */}
              {activeDialogVisible == 1 && (
                <div>
                  <div className="titleTopact">注册激活</div>
                  <div className="titleicobox">
                    <CheckCircleOutlined className="titleicon" />
                    {/* <ExclamationCircleOutlined /> */}
                  </div>
                  <div className="titlegreen">提交成功</div>

                  <div className="titlegtext">感谢你的注册！我们将在申请获批后，通过邮件通知你。</div>
                  <Button className="login-button" style={{ width: "100%" }} onClick={this.handleCancel}>
                    关闭
                  </Button>
                </div>
              )}

              {/* 2 */}
              {activeDialogVisible == 2 && (
                <div>
                  <div className="titleTopact">账户激活</div>
                  <div className="title">请设置你的密码</div>
                  <Form ref={this.formRef} colon={false} scrollToFirstError onFinish={this.handleSubmit} layout="vertical">
                    <Form.Item
                      name="loginPwd"
                      label="密码"
                      rules={[
                        {
                          required: true,
                          message: "请再次输入密码!"
                        },
                        {
                          validator: this.compareToFirstPassword
                        }
                      ]}
                    >
                      <Input className="form-item" type="password" placeholder="请再次输入密码" />
                    </Form.Item>
                    <Form.Item
                      name="confirmLoginPwd"
                      label="确认密码"
                      rules={[
                        {
                          required: true,
                          message: "请再次输入密码!"
                        },
                        {
                          validator: this.compareToFirstPassword
                        }
                      ]}
                    >
                      <Input className="form-item" type="password" placeholder="请再次输入密码" />
                    </Form.Item>

                    <div className="setpasswordbtnbox">
                      <Button onClick={this.handleCancel}>取消</Button>
                      <Button className="login-button" htmlType="submit">
                        确认
                      </Button>
                    </div>
                  </Form>
                </div>
              )}

              {/* 3 */}
              {activeDialogVisible == 3 && (
                <div>
                  <div className="titleTopact">账户激活</div>
                  <div className="titleicobox">
                    <CheckCircleOutlined className="titleicon" />
                    {/* <ExclamationCircleOutlined /> */}
                  </div>
                  <div className="titlegreen">激活成功</div>

                  <div className="titlegtext" style={{ height: "90px" }}></div>
                  <Button className="login-button" style={{ width: "100%" }} onClick={this.gologin}>
                    去登录
                  </Button>
                </div>
              )}

              {/* 4 */}
              {activeDialogVisible == 4 && (
                <div>
                  <div className="titleTopact">账户激活</div>
                  <div className="titleiconyellow">
                    <ExclamationCircleOutlined className="titleicon" />
                  </div>
                  <div className="titleyellow">激活链接已失效</div>

                  <div className="titlegtext" style={{ height: "90px" }}></div>
                  <Button className="login-button" style={{ width: "100%" }} onClick={this.retransmission}>
                    重发激活邮件
                  </Button>
                </div>
              )}

              {/* 5 */}
              {activeDialogVisible == 5 && (
                <div>
                  <div className="titleTopact">账户激活</div>
                  <div className="titleiconyellow">
                    <ExclamationCircleOutlined className="titleicon" />
                  </div>
                  <div className="titleyellow">账户已激活</div>

                  <div className="titlegtext" style={{ height: "90px" }}></div>
                  <Button className="login-button" style={{ width: "100%" }} onClick={this.gologin}>
                    去登录
                  </Button>
                </div>
              )}
            </div>
          </div>
        </Modal>
      </>
    );
  }
}

const mapStateToProps = ({ common }) => {
  const { loginDialogVisible, registerDialogVisible, activeDialogVisible } = common;
  return {
    loginDialogVisible,
    registerDialogVisible,
    activeDialogVisible
  };
};

const mapDispatchToProps = {
  changeRegisterDialogVisible,
  changeLoginDialogVisible,
  setUserinfo,
  protocolConfirm,
  changeActiveDialogVisible
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ActiveDialog);
