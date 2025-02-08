import React, { PureComponent } from "react";
import { Menu, SubMenu } from "antd";
import { Link, Redirect, Route, Switch } from "react-router-dom";
import CommonSidebar from "../../components/layout/CommonSidebar";
import Userinfo from "../../containers/user/Userinfo";
import UserSetting from "../../containers/user/UserSetting";
import UserRealName from "../../containers/user/UserRealName";
import UserController from "../../controllers/UserController";
import RouterController from "../../controllers/RouterController";
import UserAccount from "../../containers/user/UserAccount/index";
import Authorization from "../../containers/user/Authorization/index";
import "./index.less";

class User extends PureComponent {
  state = {
    menuIdArr: [],
    items: [
      {
        key: "sub1",
        label: "商户",
        children: [{ key: "authorization", label: "商户授权" }]
      },
      {
        key: "developerAccount",
        label: "开发者账户"
      }
    ]
  };

  componentDidMount() {
    this.setActiveMenu();
  }

  componentDidUpdate(prevProps) {
    const pathname = RouterController.getPathname(this.props);
    const prevPathname = RouterController.getPathname(prevProps);
    if (pathname !== prevPathname) {
      this.setActiveMenu();
    }
  }

  pushtopage = data => {
    const { history } = this.props;
    history.push(`/user/${data.key}`);
  };

  setActiveMenu = () => {
    const menuId = RouterController.getSubRouterUrl(this.props);
    console.log("kkkkk", menuId);
    this.setState({
      menuIdArr: [menuId]
    });
  };

  render() {
    const { menuIdArr, sidebarData, items } = this.state;
    const { USERINFO, SETTING, REAL_NAME } = UserController.MENU_KEY();
    return (
      <div className="user-container">
        <Menu
          style={{ width: 256 }}
          selectedKeys={menuIdArr}
          openKeys={["sub1"]}
          mode="inline"
          items={items}
          onClick={this.pushtopage}
        />
        <div className="user-right-container">
          <Switch>
            <Route exact path={`/user/authorization`} component={Authorization} />
            <Route exact path={`/user/developerAccount`} component={UserAccount} />
            <Redirect to={`/user/${USERINFO}`} />
          </Switch>
        </div>
      </div>
    );
  }
}

export default User;
