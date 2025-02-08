import React from "react";
import "../css/SubpageScenarioInfoTitle.less";

const SubpageScenarioInfoTitle = props => {
  const { title } = props;
  return (
    <div className="subpage-scenario-info-title">
      {title}
      <div className="line" />
    </div>
  );
};
export default React.memo(SubpageScenarioInfoTitle);
