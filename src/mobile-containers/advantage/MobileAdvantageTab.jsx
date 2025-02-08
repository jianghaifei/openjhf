import React from "react";
import activeImg from "../images/tab-active.png";
import "../css/MobileAdvantageTab.less";

const MobileTabItem = props => {
  const { icon, text, isActive, onClick } = props;
  return (
    <div className="mobile-tab-item" onClick={onClick}>
      {icon ? <img className="icon" src={icon} alt="icon" /> : null}
      <span className="text">{text}</span>
      {isActive ? <img className="bottom-line" src={activeImg} alt="active-img" /> : null}
    </div>
  );
};
const MobileAdvantageTab = props => {
  const { items, currentTab, onChange } = props;
  return (
    <div className="mobile-advantage-tab">
      {items.map((item, index) => {
        return <MobileTabItem {...item} key={index} isActive={index === currentTab} onClick={() => onChange(index)} />;
      })}
    </div>
  );
};

export default React.memo(MobileAdvantageTab);
