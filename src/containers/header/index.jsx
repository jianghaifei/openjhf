import React, { PureComponent } from "react";
import { withRouter } from "react-router-dom";
import { Input } from "antd";
import { SearchOutlined } from "@ant-design/icons";
import LoginDialog from "../../components/dialog/LoginDialog";
import RegisterDialog from "../../components/dialog/RegisterDialog";
import logoUrl from "../../assets/images/logo.png";
import ProtocolDialog from "../../components/dialog/ProtocolDialog";
import HeaderLoginContent from "./HeaderLoginContent";
import MenuContent from "./MenuContent";
import NavigationController from "../../controllers/NavigationController";
import ActiveDialog from "../../components/dialog/ActiveDialog";
import ResetPasswordDialog from "../../components/dialog/ResetPasswordDialog";
import "./index.less";

class OpenApiHeader extends PureComponent {
  inputRef = React.createRef();

  state = {
    isSearch: false // 如果search页面的话 隐藏search框
  };

  // componentDidUpdate() {
  //   this.setUpdateValue();
  // }

  // setUpdateValue = () => {
  //   // const pathname = RouterController.getPathname(this.props);
  //   // this.setState({
  //   //   isSearch: pathname === "/search"
  //   // });
  // };

  pushToPage = targetUrl => {
    const { history } = this.props;
    NavigationController.filterRouter(history, targetUrl);
  };

  pushToSearch = () => {
    if (!this.inputRef.current) return false;
    const { history } = this.props;
    history.push("/search", this.inputRef.current.input.value);
  };

  render() {
    const { isSearch } = this.state;
    return (
      <div className="openapi-header">
        <div className="header-content">
          <img src={logoUrl} className="logo" alt="logo" onClick={() => this.pushToPage("/")} />
          <span className="header_title" onClick={() => this.pushToPage("/")}>
            Resto 开发者平台
          </span>
          <MenuContent />
          <div className="header-right-container">
            {/* {isSearch ? null : (
              <div className="header-search">
                <Input ref={this.inputRef} suffix={<SearchOutlined onClick={this.pushToSearch} />} />
              </div>
            )} */}
            <HeaderLoginContent />
          </div>
        </div>

        <LoginDialog />
        <RegisterDialog />
        <ProtocolDialog />
        <ActiveDialog />
        <ResetPasswordDialog />
      </div>
    );
  }
}

export default withRouter(OpenApiHeader);
