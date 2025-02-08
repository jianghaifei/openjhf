import React from "react";
import { Breadcrumb } from "antd";
import "./css/CommonBreadcrumb.less";

const CommonBreadcrumb = props => {
  const { items = [], rightSlot } = props;
  return (
    <div className="common-breadcrumb">
      <Breadcrumb>
        {items?.map((item, index) => {
          return item.link ? (
            <Breadcrumb.Item key={index} href={item.link}>
              {item.text}
            </Breadcrumb.Item>
          ) : (
            <Breadcrumb.Item key={index}>{item.text}</Breadcrumb.Item>
          );
        })}
      </Breadcrumb>
      {rightSlot ? <div className="right-content">{rightSlot}</div> : null}
    </div>
  );
};
export default React.memo(CommonBreadcrumb);
