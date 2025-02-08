import React from "react";
import ReactDOM from "react-dom";
import { ConfigProvider } from "antd";
import ZH_CN from "antd/lib/locale/zh_CN";
import moment from "moment";
import "moment/locale/zh-cn";
import App from "./App";
import "./index.less";

moment.locale("zh-cn");
ReactDOM.render(
  <ConfigProvider locale={ZH_CN}>
    <App />
  </ConfigProvider>,
  document.getElementById("root")
);
