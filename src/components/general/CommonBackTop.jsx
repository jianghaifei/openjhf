import React from "react";
import { CaretUpOutlined } from "@ant-design/icons";
import { BackTop } from "antd";
import "./css/CommonBackTop.less";

const CommonBackTop = props => {
  return (
    <BackTop className="common-back-top" {...props}>
      <CaretUpOutlined />
    </BackTop>
  );
};

export default React.memo(CommonBackTop);
