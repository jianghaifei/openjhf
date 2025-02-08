import React from "react";
import "../css/DeveloperTitle.less";

const DeveloperTitle = props => {
  const { title } = props;
  return <div className="developer-title">{title}</div>;
};

export default React.memo(DeveloperTitle);
