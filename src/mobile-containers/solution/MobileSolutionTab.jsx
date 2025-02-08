import React from "react";
import activeImg from "../images/tab-active.png";
import "../css/MobileSolutionTab.less";

const TabItem = props => {
  const { text, isActive, onClick } = props;
  return (
    <div className={`tab-item ${isActive ? "tab-item-active" : ""}`} onClick={onClick}>
      {text}
      {isActive ? <img className="bottom-line" src={activeImg} alt="active-img" /> : null}
    </div>
  );
};
const MobileSolutionTab = props => {
  const { items, currentTab, onChange } = props;
  return (
    <div className="mobile-solution-tab">
      <div className="container">
        {items.map((item, index) => {
          return <TabItem text={item} key={index} isActive={index === currentTab} onClick={() => onChange(index)} />;
        })}
      </div>
    </div>
  );
};

export default React.memo(MobileSolutionTab);
