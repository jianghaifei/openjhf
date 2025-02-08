import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Button, Form, Input, message, Modal } from "antd";
import { getVerifyTelephoneRule, verifyTelephone } from "../../utils/utils";
import {
  changeLoginDialogVisible,
  changeRegisterDialogVisible,
  setUserinfo,
  protocolConfirm,
  changeActiveDialogVisible
} from "../../store/actions/Common";
import ImgCodeModal from "../../containers/image-code-dialog/ImageCodeDialog";
import LoginButton from "../../containers/auth/components/LoginButton";
import "./css/RegisterDialog.less";
import TelephoneAreaCode from "../general/TelephoneAreaCode";
import { registryApply } from "../../services/auth/authNew";
class RegisterDialog extends PureComponent {
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
    const { contact, loginPhone, loginEmail, company } = values;
    this.setState({ isLoading: true });
    registryApply(values)
      .then(res => {
        this.setState({ isLoading: false });
        console.log(res);
        if (res.code !== "000") return message.warning(res.msg);
        this.formRef.current.resetFields();
        message.success("信息提交成功");
        // // 注册成功后直接登录
        // this.props.setUserinfo({ ...res.result, isLogin: true });
        this.props.changeRegisterDialogVisible(false);
        this.props.changeActiveDialogVisible(1);
      })
      .catch(() => {
        this.setState({ isLoading: false });
      });
  };

  // 使用已有账号登录
  handleToLogin = () => {
    this.props.changeRegisterDialogVisible(false);
    this.props.changeLoginDialogVisible(true);
  };

  handleCancel = () => {
    this.formRef.current.resetFields();
    this.props.changeRegisterDialogVisible(false);
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
    const { registerDialogVisible } = this.props;
    const { isLoading, codeBtnDisabled, btnTxt, imgCodeVisible, phoneAreaCode } = this.state;
    return <>
      <Modal
        className="register-modal"
        getContainer={false}
        visible={registerDialogVisible}
        onCancel={this.handleCancel}
        width="500px"
        footer={null}
      >
        <div className="register-wrap">
          <div className="register-form">
            <div className="title">注册成为</div>
            <div className="titleTop">Resto 开发者</div>
            <Form ref={this.formRef} colon={false} scrollToFirstError onFinish={this.handleSubmit} layout="vertical">
              <Form.Item
                name="contact"
                label="姓名"
                rules={[
                  {
                    required: true,
                    message: "请输入姓名"
                  }
                  // {
                  //   pattern: /^(?![^0-9]+$)(?![^a-zA-Z]+$)[0-9A-Za-z]{6,12}$/,
                  //   message: "用户名为6-12字母数字组合!"
                  // }
                ]}
              >
                <Input className="form-item" placeholder="请输入姓名" />
              </Form.Item>
              <Form.Item
                name="loginPhone"
                label="电话号码"
                rules={[
                  { required: true, message: "请输入电话号码!" },
                  {
                    pattern: getVerifyTelephoneRule(phoneAreaCode),
                    message: "格式不正确!"
                  }
                ]}
              >
                <Input
                  className="telephone-input form-item"
                  addonBefore={<TelephoneAreaCode onChange={this.getAreaCode} />}
                  placeholder="请输入电话号码"
                />
              </Form.Item>

              <Form.Item
                name="loginEmail"
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
              <Form.Item
                name="company"
                label="公司"
                rules={[
                  {
                    required: true,
                    message: "请输入公司名称!"
                  }
                ]}
              >
                <Input className="form-item" placeholder="请输入公司名称" />
              </Form.Item>

              <LoginButton className="register-form-button" htmlType="submit" isLoading={isLoading}>
                注册
              </LoginButton>
            </Form>
            <div className="bottom-info">
              <p className="text">已有开发者账户!</p>
              <Button className="forget-password" type="link" onClick={this.handleToLogin}>
                点此登录
              </Button>
            </div>
          </div>
        </div>
        <ImgCodeModal visible={imgCodeVisible} onMatch={this.handleImgCodeMatch} onCancel={this.handleImgCodeCancel} />
      </Modal>
    </>;
  }
}

const mapStateToProps = ({ common }) => {
  const { loginDialogVisible, registerDialogVisible } = common;
  return {
    loginDialogVisible,
    registerDialogVisible
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
)(RegisterDialog);
