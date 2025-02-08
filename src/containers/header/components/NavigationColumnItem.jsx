import React from "react";
import "../css/NavigationColumnItem.less";

const NavigationColumnItem = props => {
  const { title, pushToPage } = props;
  return (
    <div className="navigation-column-item" onClick={pushToPage}>
      {title}
    </div>
  );
};

export default React.memo(NavigationColumnItem);
