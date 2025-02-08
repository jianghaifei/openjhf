import React, { lazy, PureComponent, Suspense } from "react";
import { Redirect, Route, Switch, withRouter } from "react-router-dom";
import { connect } from "react-redux";
import { message } from "antd";
import {
  changeDeveloperProtocolDialogVisible,
  changeLoginDialogVisible,
  getUserinfoByToken,
  isCookitTimeoutCheck,
  setLogout
} from "../store/actions/Common";
import { queryRealNameInfo } from "../store/actions/User";
// import { getResourceIdData } from "../store/actions/Home";
import OpenApiHeader from "../containers/header";
import OpenApiMain from "../components/layout/OpenapiMain";
import RouterController from "../controllers/RouterController";
import NavigationController from "../controllers/NavigationController";
// import Developer from "./developer";
import User from "./user";
import Document from "./resource";
// import Notice from "./notice";
// import QuestionFlat from "./question_flat";
// import Question from "./question";
// import NoData from "../components/general/NoData";
import Home from "./home";
import Mangger from "./Mangger";
import Console from "./subpage";
// import Help from "./help";
import Subpage from "./subpage";

class Framework extends PureComponent {
  componentDidMount() {
    // const { history } = this.props;
    const pathname = RouterController.getPathname(this.props);
    const pathSearch = RouterController.getPathSearch(this.props);
    // NavigationController.filterRouter(history, "/");
    // this.props.getUserinfoByToken((res = {}) => {
    //   const { result = {} } = res;
    //   const { isLogin, id: loginId } = result;
    //   if (isLogin) {
    //     this.props.queryRealNameInfo({ loginId }, res1 => {
    //       this.listenSwitchRoute({ ...res1, isLogin });
    //     });
    //   } else if (pathname.includes("user") || pathname.includes("/developer")) {
    //     message.error("请登录");
    //     this.props.changeLoginDialogVisible(true);
    //     sessionStorage.setItem("redirectUrl", pathname + pathSearch);
    //     NavigationController.filterRouter(history, "/");
    //   }
    // });

    // 获取跳转到资源列表的链接数组
    // this.props.getResourceIdData();

    const { isLogin, isRealName, checkStatus, history } = this.props;
    this.listenSwitchRoute({ isLogin });
  }

  componentDidUpdate(prevProps) {
    const { isLogin, isRealName, checkStatus } = this.props;
    const pathname = RouterController.getPathname(this.props);
    const prevPathname = RouterController.getPathname(prevProps);

    if (pathname === prevPathname) return false;
    this.listenSwitchRoute({ isLogin, isRealName, checkStatus });
  }

  getAsyncRouteLink = ({ isContainer, name }) => {
    return import(`../${isContainer ? "containers" : "views"}/${name}`);
  };

  // 每次切换路由都判断是否显示开发者协议弹框
  listenSwitchRoute({ isLogin, isRealName, checkStatus }) {
    const getCookie = name => {
      const cookies = document.cookie.split(";");
      for (let i = 0; i < cookies.length; i++) {
        const cookie = cookies[i].trim();
        if (cookie.startsWith(name + "=")) {
          return decodeURIComponent(cookie.substring(name.length + 1));
        }
      }
      return null; // 如果未找到对应 Cookie，则返回 null
    };
    this.props.isCookitTimeoutCheck();
    const { history } = this.props;
    const pathname = RouterController.getPathname(this.props);
    if (pathname.includes("user")) {
      if (!isLogin) {
        message.error("请登录");
        NavigationController.filterRouter(history, "/");
      } else if (getCookie("resto_developer_token")) {
        NavigationController.filterRouter(history, pathname);
      } else {
        this.props.setLogout();
        message.error("请登录");
        NavigationController.filterRouter(history, "/");
      }
    } else {
      NavigationController.filterRouter(history, pathname);
    }
  }

  render() {
    const items = RouterController.getRoutes();
    return (
      <>
        <OpenApiHeader />
        <OpenApiMain>
          <Suspense fallback={<div> </div>}>
            <Switch>
              {items.map((item, index) => {
                return <Route exact path={item.link} component={lazy(() => this.getAsyncRouteLink(item))} key={index} />;
              })}
              {/* 使用Link跳转的不能懒加载 懒加载会导致Link跳转重新挂载 */}
              <Route exact path="/" component={Home} />
              <Route exact path="/operation" component={Mangger} />
              <Route exact path="/resource" component={Document} />
              <Route exact path="/resource/:id" component={Document} />
              <Route path="/user" component={User} />

              {/* <Route exact path="/resource" component={Document} />
              <Route exact path="/resource/:id" component={Document} />
              <Route exact path="/notice" component={Notice} />
              <Route exact path="/help" component={Help} />
              <Route exact path="/question/flat" component={QuestionFlat} />
              <Route path="/question" component={Question} />
              <Route path="/developer" component={Developer} />
              <Route path="/subpage" component={Subpage} />
              <Route path="/user" component={User} /> */}
              <Redirect to="/" />
            </Switch>
          </Suspense>
        </OpenApiMain>
      </>
    );
  }
}

const mapStateToProps = ({ common, user }) => {
  const { isLogin } = common;
  const { isRealName, checkStatus } = user;
  return {
    isLogin,
    isRealName,
    checkStatus
  };
};
const mapDispatchToProps = {
  changeLoginDialogVisible,
  changeDeveloperProtocolDialogVisible,
  getUserinfoByToken,
  queryRealNameInfo,
  isCookitTimeoutCheck,
  setLogout
  // getResourceIdData
};
export default withRouter(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(Framework)
);
