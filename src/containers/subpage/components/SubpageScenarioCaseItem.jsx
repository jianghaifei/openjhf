import React from "react";
import "../css/SubpageScenarioCaseItem.less";

const SubpageScenarioCaseItem = props => {
  const { icon } = props;
  return (
    <div className="subpage-scenario-case-item">
      <img className="icon" src={icon} alt="icon" />
    </div>
  );
};
export default React.memo(SubpageScenarioCaseItem);
