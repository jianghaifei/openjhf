import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { CloseCircleFilled, ExclamationCircleFilled } from "@ant-design/icons";
import { Alert } from "antd";
import UserName from "./components/UserName";
import { queryRealNameInfo } from "../../store/actions/User";
import "./css/Userinfo.less";
import UserController from "../../controllers/UserController";

class Userinfo extends PureComponent {
  state = {
    companyName: "",
    companyAddr: "",
    linkmanName: "",
    linkmanPosition: "",
    linkmanPhone: "",
    linkmanEmail: "",
    reason: ""
  };

  componentDidMount() {
    this.getData();
  }

  componentWillUnmount() {
    // 销毁后防止继续setState
    this.setState = () => {};
  }

  // 查询用户信息
  getData() {
    const { loginId } = this.props;
    this.props.queryRealNameInfo({ loginId, isEncrypt: 1 }, result => {
      this.setState({ ...result });
    });
  }

  handleToRealName = () => {
    const { history } = this.props;
    const { REAL_NAME } = UserController.MENU_KEY();
    history.push(`/user/${REAL_NAME}`);
  };

  renderInfo = () => {
    const { checkStatus } = this.props;
    const { companyName, companyAddr, linkmanName, linkmanPosition, linkmanPhone, linkmanEmail, reason } = this.state;
    switch (checkStatus) {
      case 1:
        return (
          <Alert
            message="实名认证信息审核中..."
            description="实名认证信息审核中，我们将会在1-3个工作日内进行人工审核，请耐心等待。"
            type="warning"
            showIcon
            icon={<ExclamationCircleFilled />}
          />
        );
      case 2:
        return (
          <Alert
            message="人工审核失败"
            description={
              <span>
                您提交的实名认证存在如下错误: {reason}
                <br />
                请核对并修改信息后，再重新提交
                <span className="color-link-blue" onClick={this.handleToRealName}>
                  返回修改
                </span>
              </span>
            }
            type="error"
            showIcon
            icon={<CloseCircleFilled />}
          />
        );
      case 3:
        return (
          <div>
            <p className="pl-10 fz-16 fw-800 main-info-title">主体信息</p>
            <ul className="pl-24 ">
              <li className="main-info-title">
                公司名称:
                {companyName}
              </li>
              <li className="main-info-title">
                {" "}
                公司地址:
                {companyAddr}
              </li>
            </ul>
            <p className="pl-10 fz-16 fw-800 main-info-title">联系人信息</p>
            <ul className="pl-24 ">
              <li className="main-info-title">
                姓名:
                {linkmanName || "---"}
              </li>
              <li className="main-info-title">
                职务:
                {linkmanPosition || "---"}
              </li>
              <li className="main-info-title">
                手机号码:
                {linkmanPhone || "---"}
              </li>
              <li className="main-info-title">
                邮箱地址:
                {linkmanEmail || "---"}
              </li>
            </ul>
          </div>
        );
      default:
        return (
          <Alert
            message="您尚未实名认证"
            description={
              <span>
                实名认证成功后，您可获得接入平台的权限，并感受更多接口对接服务。
                <span className="color-link-blue" onClick={this.handleToRealName}>
                  立即实名认证
                </span>
              </span>
            }
            type="warning"
            showIcon
            icon={<ExclamationCircleFilled />}
          />
        );
    }
  };

  render() {
    const { isRealName, checkStatus } = this.props;
    return (
      <>
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
        <div style={{ padding: "0 24px" }}>
          <h1 className="title-20">账户信息</h1>
          <UserName isRealName={isRealName} checkStatus={checkStatus} />
          <h2 className="border-title mb-16"> 实名认证信息</h2>
          {this.renderInfo()}
        </div>
      </>
    );
  }
}
const mapStateToProps = ({ common, user }) => {
  const { loginId } = common;
  const { isRealName, checkStatus } = user;
  return {
    loginId,
    isRealName,
    checkStatus
  };
};
const mapDispatchToProps = {
  queryRealNameInfo
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Userinfo);
