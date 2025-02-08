import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { EyeOutlined } from "@ant-design/icons";
import { Alert, Col, message, Modal, Row } from "antd";
import * as utility from "utility";
import TelephoneLoginService from "../../services/auth/TelephoneLoginService";
import PasswordLoginService from "../../services/auth/PasswordLoginService";
import AuthService from "../../services/auth/AuthService";
import ResetPwdModal from "./components/ResetPwdModal";
import ResetPhoneModal from "./components/ResetPhoneModal";
import { queryRealNameInfo } from "../../store/actions/User";
import { changeLoginDialogVisible, changePhoneNum, setLogout } from "../../store/actions/Common";
import UserController from "../../controllers/UserController";
import NavigationController from "../../controllers/NavigationController";
import "./css/UserSetting.less";

const { confirm } = Modal;

class UserSetting extends PureComponent {
  state = {
    appKey: undefined,
    appSecret: undefined,
    showResetPwdModal: false,
    showResetPhoneModal: false,
    showAppsecret: false
  };

  componentDidMount() {
    this.queryRealNameInfo();
  }

  componentWillUnmount() {
    this.setState = () => {};
  }

  // 查询用户信息
  queryRealNameInfo = () => {
    const { loginId } = this.props;
    // 查询用户信息
    this.props.queryRealNameInfo({ loginId }, result => {
      const { id, appKey, appSecret } = result;
      this.setState({ id, appKey, appSecret });
    });
  };

  handleToRealName = () => {
    const { history } = this.props;
    const { REAL_NAME } = UserController.MENU_KEY();
    NavigationController.filterRouter(history, `/user/${REAL_NAME}`);
  };

  resetAppSecret = () => {
    const { id } = this.state;
    const that = this;
    confirm({
      title: "确认是否对该开发者密钥信息进行重置？",
      content: "重置成功后续将采用该密钥获取信息，你还要继续吗？",
      onOk() {
        AuthService.resetAppSecret({ platUserId: id }).then(res => {
          if (res.code !== "000") return false;
          that.queryRealNameInfo();
        });
      }
    });
  };

  resetPwd = () => {
    this.setState({ showResetPwdModal: true });
  };

  handleResetPwdConfirm = values => {
    const { loginId } = this.props;
    const newPwd = utility.md5(values.newPwd);
    const oldPwd = utility.md5(values.oldPwd);
    PasswordLoginService.resetPasswordByOld({ loginId, newPwd, oldPwd }).then(res => {
      if (res.code !== "000") return false;
      this.setState({ showResetPwdModal: false });
      this.props.history.push("/");
      message.success("密码修改成功,请重新登录", 3);
      this.props.setLogout();
      this.props.changeLoginDialogVisible(true);
    });
  };

  handleResetPwdCancel = () => {
    this.setState({ showResetPwdModal: false });
  };

  resetPhone = () => {
    this.setState({ showResetPhoneModal: true });
  };

  handleResetPhoneConfirm = values => {
    const { loginId } = this.props;
    const params = {
      ...values,
      loginPwd: utility.md5(values.loginPwd),
      loginId
    };
    TelephoneLoginService.resetPhone(params).then(res => {
      if (res.code !== "000") return false;
      this.props.changePhoneNum(params.phoneNum);
      sessionStorage.setItem("phone", params.phoneNum);
      this.setState({ showResetPhoneModal: false });
      message.success("手机号修改成功", 3);
    });
  };

  handleResetPhoneCancel = () => {
    this.setState({ showResetPhoneModal: false });
  };

  handleShowAppSecret = () => {
    const { showAppsecret } = this.state;
    this.setState({
      showAppsecret: !showAppsecret
    });
  };

  render() {
    const { phone, checkStatus } = this.props;
    const { appKey, appSecret, showResetPwdModal, showResetPhoneModal, showAppsecret } = this.state;
    return (
      <div className="user-setting">
        {!checkStatus ? (
          <Alert
            message={
              <span>
                您的账户未进行实名认证，部分功能将受限，请尽快完成{" "}
                <span className="color-link-blue" onClick={this.handleToRealName}>
                  立即实名认证
                </span>
              </span>
            }
            type="warning"
            showIcon
          />
        ) : null}
        <div style={{ padding: "0 44px" }}>
          <h1 className="title-20">安全设置</h1>
          <Row className="set-item">
            <Col span={2}>
              {" "}
              <span className="icon iconfont" style={{ color: "#19a3ff", fontSize: 30 }}>
                &#xe98e;
              </span>
            </Col>
            <Col span={16}>
              <p className="title">开发者key&密钥</p>
              <p>
                appKey:{appKey || "---"}; &nbsp;appSecret:{appSecret ? (showAppsecret ? appSecret : `******${appSecret.slice(-2)}`) : "---"}
                <EyeOutlined style={{ cursor: "pointer" }} onClick={this.handleShowAppSecret} />
              </p>
            </Col>
            <Col span={6} className="color-link-blue" onClick={this.resetAppSecret}>
              重置密钥
            </Col>
          </Row>
          <Row className="set-item">
            <Col span={2}>
              {" "}
              <span className="icon iconfont icon-lock" style={{ color: "#28bc79", fontSize: 30 }} />
            </Col>
            <Col span={16}>
              <p className="title">登录密码</p>
              <p>用于登录开放平台，请输入8-12位英文字母数字和下划线组合</p>
            </Col>
            <Col span={6} className="color-link-blue" onClick={this.resetPwd}>
              修改密码
            </Col>
          </Row>
          <Row className="set-item">
            <Col span={2}>
              <span className="icon iconfont" style={{ color: "#ffa202", fontSize: 30 }}>
                &#xe98d;
              </span>
            </Col>
            <Col span={16}>
              <p className="title">手机号码</p>
              <p>
                已绑定手机号码:
                {phone ? `${phone.substring(0, 3)}****${phone.substring(7)}` : ""}
              </p>
            </Col>
            <Col span={6} className="color-link-blue" onClick={this.resetPhone}>
              立即修改
            </Col>
          </Row>
        </div>
        <ResetPwdModal visible={showResetPwdModal} onCancel={this.handleResetPwdCancel} onCreate={this.handleResetPwdConfirm} />
        <ResetPhoneModal visible={showResetPhoneModal} onCancel={this.handleResetPhoneCancel} onCreate={this.handleResetPhoneConfirm} />
      </div>
    );
  }
}

const mapStateToProps = ({ common, user }) => {
  const { loginId, phone } = common;
  const { checkStatus } = user;
  return {
    loginId,
    phone,
    checkStatus
  };
};
const mapDispatchToProps = {
  queryRealNameInfo,
  changePhoneNum,
  changeLoginDialogVisible,
  setLogout
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(UserSetting);
