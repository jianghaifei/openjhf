import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Button, Form, Input, message, Statistic } from "antd";
import { withRouter } from "react-router-dom";
import { getCountdown, verifyTelephone, getVerifyTelephoneRule } from "../../utils/utils";
import TelephoneLoginService from "../../services/auth/TelephoneLoginService";
import AuthService from "../../services/auth/AuthService";
import ImgCodeModal from "../image-code-dialog/ImageCodeDialog";
import LoginButton from "./components/LoginButton";
import { changeLoginDialogVisible, changeRegisterDialogVisible, getUserinfoByToken } from "../../store/actions/Common";
import { queryRealNameInfo } from "../../store/actions/User";
import TelephoneAreaCode from "../../components/general/TelephoneAreaCode";
import NavigationController from "../../controllers/NavigationController";

const { Countdown } = Statistic;
class TelephoneLogin extends PureComponent {
  formRef = React.createRef();

  state = {
    isLoading: false,
    btnTxt: "获取验证码",
    codeBtnDisabled: false,
    imgCodeVisible: false,
    phoneAreaCode: null
  };

  componentDidMount() {
    this.props.getFormRef("telephone", this.formRef);
  }

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
    const params = { phoneAreaCode, phoneNum, type: 1, imgCode: data };
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

  handleImgCodeCancel = () => {
    this.setState({ imgCodeVisible: false });
  };

  // 手机号登录 点击登录
  submitSuccess = values => {
    const { history } = this.props;
    this.setState({ isLoading: true });
    TelephoneLoginService.loginByTelephone(values)
      .then(res => {
        const { code, result } = res;
        // 登录成功，设置登录信息
        if (code !== "000") return false;
        NavigationController.loginSuccessful(this.formRef, result.id, history);
      })
      .finally(() => {
        this.setState({ isLoading: false });
      });
  };

  // 点击去注册
  pushToRegister = () => {
    this.props.changeLoginDialogVisible(false);
    this.props.changeRegisterDialogVisible(true);
  };

  getAreaCode = value => {
    this.formRef.current.setFieldsValue({
      phoneNum: ""
    });
    this.setState({ phoneAreaCode: value });
  };

  render() {
    const { isLoading, codeBtnDisabled, btnTxt, imgCodeVisible, phoneAreaCode } = this.state;
    return (
      <>
        <Form ref={this.formRef} onFinish={this.submitSuccess}>
          <Form.Item
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
              className="telephone-input form-item"
              addonBefore={<TelephoneAreaCode onChange={this.getAreaCode} />}
              placeholder="请输入手机号"
            />
          </Form.Item>
          <Form.Item name="identifyCode" rules={[{ required: true, message: "请输入验证码!" }]}>
            <Input
              className="form-item form-item-code-input"
              placeholder="请输入验证码"
              suffix={
                <Button className="form-code-button" disabled={codeBtnDisabled} onClick={this.handleSendMsgCode}>
                  {btnTxt}
                </Button>
              }
            />
          </Form.Item>

          <LoginButton className="login-form-button" htmlType="submit" isLoading={isLoading}>
            登录
          </LoginButton>
        </Form>
        <div className="tips-register">
          <span className="text">还没有账号?</span>
          <div className="btn" onClick={this.pushToRegister.bind(this)}>
            注册
          </div>
        </div>
        <ImgCodeModal visible={imgCodeVisible} onMatch={this.handleImgCodeMatch} onCancel={this.handleImgCodeCancel} />
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
  changeLoginDialogVisible,
  changeRegisterDialogVisible,
  queryRealNameInfo,
  getUserinfoByToken
};
export default withRouter(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(TelephoneLogin)
);
