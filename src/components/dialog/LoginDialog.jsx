import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Form, Button, Input, message, Modal, Tabs } from "antd";
import {
  changeLoginDialogVisible,
  getUserinfoByToken,
  changeRegisterDialogVisible,
  saveLoginInfo,
  changeRestPasswordDialogVisible,
  setUserinfo
} from "../../store/actions/Common";
import "./css/LoginDialog.less";
import LoginButton from "../../containers/auth/components/LoginButton";
import { loginCheckUser, loginPasswordfn, infoDetail } from "../../services/auth/authNew";
const { TabPane } = Tabs;

class LoginDialog extends PureComponent {
  formRef = React.createRef();
  state = {
    loginMethod: "1",
    isLoading: false,
    showCodeInput: false,
    email: ""
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
    const { accountFormRef, telephoneFormRef } = this.state;
    if (accountFormRef && accountFormRef.current) {
      accountFormRef.current.resetFields();
    }
    if (telephoneFormRef && telephoneFormRef.current) {
      telephoneFormRef.current.resetFields();
    }
    this.props.changeLoginDialogVisible(false);
  };

  restPasswordFn = () => {
    this.props.changeRestPasswordDialogVisible(true);
    this.props.changeLoginDialogVisible(false);
  };

  changeDialogFunction = () => {
    alert("aaa");
  };

  // 忘记密码
  handleForgetPwd = () => {
    this.props.changeRegisterDialogVisible(true);
    this.props.changeLoginDialogVisible(false);
  };

  componentDidMount() {
    const { loginDialogVisible } = this.props;
    if (loginDialogVisible) {
      this.formRef.current.resetFields();
      this.setState({ showCodeInput: false });
    }
    // const form = document.querySelector('form');
    // form.setAttribute('autoComplete', 'on');

    // document.getElementById('email').dispatchEvent(new Event('input'));
  }

  // componentDidUpdate(prevProps, prevState) {
  //   // 检查 state 是否发生变化
  //   if (prevState.showCodeInput) {
  //     this.formRef.current.resetFields();
  //     this.setState({ showCodeInput: false });
  //   }
  // }

  formSuccess = values => {
    const { email: loginEmail, loginPassword } = values;
    const { showCodeInput, email } = this.state;
    if (!showCodeInput) {
      loginCheckUser({ loginEmail }).then(res => {
        if (res.code != "000") {
          return message.warning("登录邮箱不合法");
        }
        this.setState({ showCodeInput: true, email: loginEmail });
      });
      return;
    }

    this.setState({ isLoading: true });
    loginPasswordfn({ loginEmail: email, loginPassword })
      .then(res => {
        this.setState({ showCodeInput: false, isLoading: false });
        this.formRef.current.resetFields();
        if (res.code != "000") {
          return message.warning(res.msg);
        }
        this.formRef.current.resetFields();
        message.success("登录成功");
        this.props.changeLoginDialogVisible(false);
        infoDetail({}).then(res => {
          console.log("sssss", res);
          this.props.setUserinfo({ ...res.data, isLogin: true });
        });
      })
      .finally(() => {
        this.setState({ showCodeInput: false, isLoading: false });
      });
  };

  render() {
    const { loginDialogVisible } = this.props;
    const { isLoading, showCodeInput, imgUrl } = this.state;
    return (
      <Modal className="login-modal" getContainer={false} visible={loginDialogVisible} onCancel={this.onCancel} width="500px" footer={null}>
        <div className="login-wrap">
          <div className="login-form">
            <div className="titleTop">欢迎</div>
            <div className="title">登录到 Resto 开发者平台</div>
            <>
              <Form ref={this.formRef} onFinish={this.formSuccess} name="basic" layout="vertical" autoComplete="off">
                {showCodeInput ? (
                  <Form.Item name="loginPassword" label="密码" rules={[{ required: true, message: "请输入密码!" }]}>
                    <Input className="form-item" type="password" placeholder="请输入密码" autoComplete="current-password" />
                  </Form.Item>
                ) : (
                  <Form.Item
                    name="email"
                    layout="vertical"
                    label="邮箱"
                    rules={[
                      {
                        required: true,
                        message: "请输入邮箱!"
                      },
                      {
                        pattern: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/,
                        message: "格式不正确!"
                      }
                    ]}
                  >
                    <Input id="username" name="username" className="form-item" placeholder="请输入邮箱" autoComplete="username" />
                  </Form.Item>
                )}

                <p className="form-item-text" onClick={this.restPasswordFn}>
                  忘记密码
                </p>
                <LoginButton className="login-form-button" htmlType="submit" isLoading={isLoading}>
                  {showCodeInput ? "登录" : "下一步"}
                </LoginButton>
              </Form>

              <div className="bottom-info">
                <p className="text">成为开发者!</p>
                <Button className="forget-password" type="link" onClick={this.handleForgetPwd}>
                  由此开始
                </Button>
              </div>
            </>
            {/* <AccountLogin getFormRef={this.getFormRef} changeDialogFunction={this.changeDialogFunction} /> */}
          </div>
        </div>
      </Modal>
    );
  }
}

const mapStateToProps = ({ common }) => {
  const { loginDialogVisible } = common;
  return {
    loginDialogVisible
  };
};
const mapDispatchToProps = {
  changeLoginDialogVisible,
  getUserinfoByToken,
  changeRegisterDialogVisible,
  saveLoginInfo,
  changeRestPasswordDialogVisible,
  setUserinfo
};
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(LoginDialog);
