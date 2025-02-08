import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import { Form, Button, Col, Input, message, Row } from "antd";
import { md5 } from "utility";
import { nanoid } from "nanoid";
import PasswordLoginService from "../../services/auth/PasswordLoginService";
import LoginButton from "./components/LoginButton";
import {
  changeLoginDialogVisible,
  getUserinfoByToken,
  changeRegisterDialogVisible,
  saveLoginInfo,
  changeRestPasswordDialogVisible,
  setUserinfo,
} from "../../store/actions/Common";
import { queryRealNameInfo } from "../../store/actions/User";
import NavigationController from "../../controllers/NavigationController";
import Config from "../../Config";

import { loginCheckUser, loginPasswordfn, infoDetail } from "../../services/auth/authNew";
class AccountLogin extends PureComponent {
  formRef = React.createRef();

  state = {
    isLoading: false,
    showCodeInput: false,
    email: ""
  };

  componentDidMount() {
    this.props.getFormRef("account", this.formRef);
  }

  formSuccess = values => {
    const { loginEmail, loginPassword } = values;
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

  // 忘记密码
  handleForgetPwd = () => {
    // this.props.changeRegisterDialogVisible(true);
    this.props.changeLoginDialogVisible(false);
  };

  handleClick = () => {
    this.formRef.current.validateFields();
    this.setState({ showCodeInput: true });
  };

  restPasswordFn = () => {
    this.props.changeRestPasswordDialogVisible(true);
    this.props.changeLoginDialogVisible(false);
  };

  render() {
    const { isLoading, showCodeInput, imgUrl } = this.state;
    return (
      <>
        <Form ref={this.formRef} onFinish={this.formSuccess} layout="vertical">
          {showCodeInput ? (
            <Form.Item name="loginPassword" label="密码" rules={[{ required: true, message: "请输入密码!" }]}>
              <Input className="form-item" type="password" placeholder="请输入密码" />
            </Form.Item>
          ) : (
            <Form.Item
              name="loginEmail"
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
              <Input className="form-item" placeholder="请输入邮箱" />
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
  changeRegisterDialogVisible,
  changeLoginDialogVisible,
  queryRealNameInfo,
  getUserinfoByToken,
  saveLoginInfo,
  changeRestPasswordDialogVisible,
  setUserinfo,
};
export default withRouter(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(AccountLogin)
);
