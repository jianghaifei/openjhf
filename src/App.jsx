import React from "react";
import { Provider } from "react-redux";
import { BrowserRouter } from "react-router-dom";
import { BrowserView } from "react-device-detect";
import store from "./store";
import RouterGuard from "./views/Framework";
// import OpenApiMobile from "./mobile-views/home";
import "./assets/iconfont/iconfont.css";
import "./assets/reset.css";
import "./assets/App.less";

const App = () => {
  return (
    <Provider store={store}>
      {/* pc端 */}
      <BrowserView>
        <BrowserRouter>
          <RouterGuard />
        </BrowserRouter>
      </BrowserView>
      {/* 移动端 */}
      {/* <MobileView>
        <OpenApiMobile />
      </MobileView> */}
    </Provider>
  );
};

export default React.memo(App);
