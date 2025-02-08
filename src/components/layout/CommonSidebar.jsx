import React, { useState } from "react";
import { LeftSquareFilled, RightSquareFilled } from "@ant-design/icons";
import "./css/Sidebar.less";

const CommonSidebar = props => {
  const { title = "", children, top = 90, isFixed = true, showWider = false } = props;
  const [isWider, updateIsWider] = useState(false);
  const widerWidth = 380;

  const handleIconClick = () => {
    updateIsWider(!isWider);
  };

  return (
    <div>
      <div className="common-sidebar" style={{ position: isFixed ? "fixed" : "", top, width: isWider ? widerWidth : 242 }}>
        <div className="side-title">{title}</div>
        <div className="side-content">{children}</div>
        {showWider && (
          <div className="wider-icon" onClick={handleIconClick}>
            {isWider ? <LeftSquareFilled /> : <RightSquareFilled />}
          </div>
        )}
      </div>
      {/** 占位符 侧边栏是固定定位 帮忙撑开侧边栏原有的位置 */}
      {isFixed ? <div className="empty-div" style={{ width: isWider ? widerWidth : 242 }} /> : null}
    </div>
  );
};
export default React.memo(CommonSidebar);
