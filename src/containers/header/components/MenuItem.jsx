import React from "react";
import "../css/MenuItem.less";

const MenuItem = props => {
  const { children, isPopOver, listenItemClick, isActive, changeNavigationVisible } = props;
  const mouseEnter = () => {
    if (!isPopOver) return false;
    changeNavigationVisible(true);
  };
  const mouseLeave = () => {
    if (!isPopOver) return false;
    changeNavigationVisible(false);
  };
  return (
    <div
      className={`menu-item ${isActive ? "menu-item-active" : ""}`}
      onClick={listenItemClick}
      onMouseEnter={mouseEnter}
      onMouseLeave={mouseLeave}
    >
      {children}
    </div>
  );
};

export default React.memo(MenuItem);
