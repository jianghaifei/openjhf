import React, { PureComponent } from "react";
import { withRouter } from "react-router-dom";
import { connect } from "react-redux";
import { changeCurrentMenuIndex } from "../../store/actions/Header";
import NavigationController from "../../controllers/NavigationController";
import RouterController from "../../controllers/RouterController";
import "./css/OpenapiMain.less";

class OpenapiMain extends PureComponent {
  state = {};

  componentDidMount() {
    this.setTopMenuIndex();
  }

  componentDidUpdate(prevProps) {
    const pathname = RouterController.getPathname(this.props);
    const prevPathname = RouterController.getPathname(prevProps);
    // 切换页面回滚到顶部&&判断头部导航高亮状态
    if (pathname !== prevPathname) {
      window.scrollTo(0, 0);
      this.setTopMenuIndex();
    }
  }

  setTopMenuIndex = () => {
    const pathname = RouterController.getPathname(this.props);
    const { RESOURCE, DEVELOPER, QUESTION } = NavigationController.TOP_MENU_KEY();
    let menuIndex;
    switch (true) {
      case pathname.includes("/resource"):
        menuIndex = RESOURCE;
        break;
      case pathname.includes("/developer"):
        menuIndex = DEVELOPER;
        break;
      case pathname.includes("/question"):
        menuIndex = QUESTION;
        break;
      default:
        menuIndex = null;
    }
    this.props.changeCurrentMenuIndex(menuIndex);
  };

  render() {
    const { children } = this.props;
    return <div className="openapi-main">{children}</div>;
  }
}

const mapStateToProps = state => {
  return { currentMenuIndex: state.header.currentMenuIndex };
};
const mapDispatchToProps = {
  changeCurrentMenuIndex
};
export default withRouter(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(OpenapiMain)
);
