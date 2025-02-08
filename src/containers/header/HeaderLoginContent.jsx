import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import { DownOutlined, UserOutlined } from "@ant-design/icons";
import { Avatar, Dropdown, Menu, message } from "antd";
import {
  changeLoginDialogVisible,
  changeRegisterDialogVisible,
  setLogout,
  changeActiveDialogVisible,
  changeRestPasswordDialogVisible
} from "../../store/actions/Common";
import NavigationController from "../../controllers/NavigationController";
import RouterController from "../../controllers/RouterController";
import "./css/HeaderLoginContent.less";
import { registryActive } from "../../services/auth/authNew";
class HeaderLoginContent extends PureComponent {
  // 点击登录
  handleLoginClick = () => {
    const { isLogin } = this.props;
    if (isLogin) return false;
    this.props.changeLoginDialogVisible(true);
  };

  // 点击注册
  handleRegisterClick = () => {
    const { isLogin } = this.props;
    if (isLogin) return false;
    this.props.changeRegisterDialogVisible(true);
  };

  handleActiveClick = key => {
    this.props.changeActiveDialogVisible(key);
  };

  handleRestPasswordClick = () => {
    this.props.changeRestPasswordDialogVisible(true);
  };

  setLogout = () => {
    this.pushToPage("/");
    this.props.setLogout();
    function deleteCookie(name, path = '/') {
      document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=${path};`;
    }
    deleteCookie('resto_developer_token', '/');
  };

  setLoginMenu = () => {
    return (
      <Menu>
        {/* <Menu.Item key="1" onClick={() => this.pushToPage("/user")}>
          账户信息
        </Menu.Item> */}
        <Menu.Item key="2" onClick={this.setLogout}>
          退出
        </Menu.Item>
      </Menu>
    );
  };

  pushToPage = targetUrl => {
    const { history } = this.props;
    NavigationController.filterRouter(history, targetUrl);
  };

  componentDidMount() {
    // console.log("dddddd", location.search);
    // 创建 URLSearchParams 对象
    const params = new URLSearchParams(location.search);

    // 获取 loginEmail 和 activeCode 的值
    const loginEmail = params.get("loginEmail");
    const activeCode = params.get("activeCode");

    // console.log("loginEmail:", loginEmail); // 输出: loginEmail: jianghaifei@restosuite.ai
    // console.log("activeCode:", activeCode); // 输出: activeCode: rBzBth
    const { isLogin, contact } = this.props;
    if (loginEmail && activeCode && !isLogin) {
      registryActive({ loginEmail, activeCode }).then(res => {
        console.log("ddddd", res.code);
        if (res.code == 6) {
          message.warning("开发者不存在, 对应参数loginEmail 没有发起过申请, 所以不存在激活的情况");
        }
        if (res.code == "000") {
          this.props.changeActiveDialogVisible(2);
        }
        if (res.code == "9") {
          this.props.changeActiveDialogVisible(4);
        }
        if (res.code == "10") {
          this.props.changeActiveDialogVisible(5);
        }
      });
    }
  }

  render() {
    const { isLogin, contact } = this.props;

    return (
      <div className="login-container">
        {isLogin ? (
          <Dropdown overlay={this.setLoginMenu()} placement="bottomLeft">
            <div className="active pointer">
              <span style={{ paddingLeft: "20px" }}>{contact}</span>
              <DownOutlined style={{ paddingTop: "3px", marginLeft: "5px" }} />
            </div>
          </Dropdown>
        ) : (
          <>
            <span className="pointer" onClick={this.handleLoginClick}>
              登录
            </span>
            <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
            <span className="pointer" onClick={this.handleRegisterClick}>
              注册
            </span>
            {/* <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span> */}
            {/* <span className="pointer" onClick={this.handleRestPasswordClick}>
              重置
            </span>
            <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span> */}
            {/* <span className="pointer" onClick={() => this.handleActiveClick(1)}>
              激活1
            </span>
            <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
            <span className="pointer" onClick={() => this.handleActiveClick(2)}>
              激活2
            </span>
            <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
            <span className="pointer" onClick={() => this.handleActiveClick(3)}>
              激活3
            </span>
            <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
            <span className="pointer" onClick={() => this.handleActiveClick(4)}>
              激活4
            </span>
            <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
            <span className="pointer" onClick={() => this.handleActiveClick(5)}>
              激活5
            </span> */}
          </>
        )}
      </div>
    );
  }
}

const mapStateToProps = ({ common }) => {
  const { isLogin, contact } = common;
  return {
    isLogin,
    contact
  };
};
const mapDispatchToProps = {
  setLogout,
  changeLoginDialogVisible,
  changeRegisterDialogVisible,
  changeActiveDialogVisible,
  changeRestPasswordDialogVisible
};

export default withRouter(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(HeaderLoginContent)
);
