import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Modal, Tabs, Form, Input, Button, message } from "antd";
import { changeLoginDialogVisible, changeRestPasswordDialogVisible } from "../../store/actions/Common";
import "./css/LoginDialog.less";
const { TabPane } = Tabs;
import { verifyEmail } from "../../utils/utils";

import { getVerificationCode, setNewPassword } from "../../services/auth/authNew";
class RegisterDialog extends PureComponent {
  formRef = React.createRef();

  state = {
    loginMethod: "1",
    isLoading: false,
    showCodeInput: false,
    codeBtnDisabled: false,
    btnTxt: "获取验证码",
    timeOutCurrent: null,
    email: "",
    code: ""
  };

  // 登录方式切换
  loginMethodChange = key => {
    this.setState({ loginMethod: key });
  };

  getFormRef = (type, ref) => {
    this.setState({
      accountFormRef: type === "account" ? ref : "",
      telephoneFormRef: type === "telephone" ? ref : ""
    });
  };

  // 点击取消
  onCancel = () => {
    this.props.changeRestPasswordDialogVisible(false);
  };

  changeDialogFunction = () => {
    alert("aaa");
  };

  //

  // 点击获取验证码
  handleSendMsgCode = () => {
    const { phoneAreaCode } = this.state;
    const loginEmail = this.formRef.current.getFieldValue("loginEmail");
    if (verifyEmail(loginEmail)) {
      getVerificationCode({ loginEmail }).then(res => {
        if (res.code != "000") return message.warning(res.msg);
        this.handelCountdown();
      });
    } else {
      message.error("请输入有效邮箱");
    }
  };

  // 倒计时
  handelCountdown = () => {
    const { timeOutCurrent } = this.state;
    let num = 60;
    if (!timeOutCurrent) {
      this.setState({ btnTxt: `${60}s后从新获取` });
      this.state.timeOutCurrent = setInterval(() => {
        num--;
        if (num == 0) {
          clearInterval(this.state.timeOutCurrent);
          this.state.timeOutCurrent = null;
          this.setState({ btnTxt: "获取验证码" });
        } else {
          this.setState({ btnTxt: `${num}s后从新获取` });
        }
      }, 1000);
    }
  };

  componentWillUnmount() {
    if (this.state.timeOutCurrent) {
      clearInterval(this.state.timeOutCurrent);
    }
  }

  handleSubmit = values => {
    const { loginEmail, verificationCode, confirmLoginPwd } = values;
    const { showCodeInput, email, code } = this.state;
    if (!showCodeInput) {
      this.setState({ showCodeInput: true, email: loginEmail, code: verificationCode });
      return;
    }
    this.setState({ isLoading: true });
    const params = {
      loginEmail: email,
      verificationCode: code,
      newPassword: confirmLoginPwd
    };
    setNewPassword(params).then(res => {
      if (res.code != "000") return;
      message.success("重置密码成功!");
      this.formRef.current.resetFields();
      this.setState({ showCodeInput: false, email: "", code: "" });
      this.props.changeRestPasswordDialogVisible(false);
      this.props.changeLoginDialogVisible(true);
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

  render() {
    const { restPasswordDialogVisible } = this.props;
    const { showCodeInput, isLoading, codeBtnDisabled, btnTxt } = this.state;
    return (
      <Modal
        className="login-modal"
        getContainer={false}
        visible={restPasswordDialogVisible}
        onCancel={this.onCancel}
        width="500px"
        footer={null}
      >
        <div className="login-wrap">
          <div className="login-form">
            <div className="titleTop">重置密码</div>
            <div className="titlep">{!showCodeInput ? "请输入你的邮箱，我们将发送验证码，以重置你的密码。" : "请输入新密码"}</div>
            <Form ref={this.formRef} onFinish={this.handleSubmit} layout="vertical" autoComplete="off">
              {!showCodeInput ? (
                <div>
                  <Form.Item name="loginEmail" layout="vertical" label="邮箱" rules={[{ required: true, message: "请输入邮箱!" }]}>
                    <Input className="form-item" placeholder="请输入邮箱" id="username" name="username" autoComplete="username" />
                  </Form.Item>

                  <Form.Item
                    name="verificationCode"
                    label="验证码"
                    rules={[
                      {
                        required: true,
                        message: "请输入验证码!"
                      }
                    ]}
                  >
                    <Input
                      className="form-item form-item-code-input"
                      placeholder="请输入验证码"
                      suffix={
                        <Button
                          className="form-code-button"
                          style={{ paddingRight: "10px" }}
                          disabled={codeBtnDisabled}
                          onClick={() => {
                            if (btnTxt == "获取验证码") {
                              this.handleSendMsgCode();
                            }
                          }}
                        >
                          {btnTxt}
                        </Button>
                      }
                    />
                  </Form.Item>
                </div>
              ) : (
                <div>
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
                </div>
              )}

              <div className="setpasswordbtnbox" style={{ marginTop: "30px" }}>
                <Button onClick={this.onCancel}>取消</Button>
                <Button className="login-button" htmlType="submit">
                  {!showCodeInput ? "下一步" : "确认"}
                </Button>
              </div>
            </Form>
          </div>
        </div>
      </Modal>
    );
  }
}

const mapStateToProps = ({ common }) => {
  const { loginDialogVisible, restPasswordDialogVisible } = common;
  return {
    loginDialogVisible,
    restPasswordDialogVisible
  };
};
const mapDispatchToProps = {
  changeLoginDialogVisible,
  changeRestPasswordDialogVisible
};
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(RegisterDialog);
