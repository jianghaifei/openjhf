import React from "react";
import "../css/SubpageScenarioServiceItem.less";

const SubpageScenarioServiceItem = props => {
  const { icon, text } = props;
  return (
    <div className="subpage-scenario-service-item">
      <img className="icon" src={icon} alt="icon" />
      <div className="text">{text}</div>
    </div>
  );
};
export default React.memo(SubpageScenarioServiceItem);
