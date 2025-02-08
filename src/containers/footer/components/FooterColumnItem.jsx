import React from "react";
import "../css/FooterColumnItem.less";

const FooterColumnItem = props => {
  const { title, linkKey, root, pushToPage } = props;
  return (
    <div
      className={`footer-column-item ${root || linkKey ? "can-hover" : ""}`}
      style={{ cursor: root || linkKey ? "pointer" : "default" }}
      onClick={pushToPage}
    >
      {title}
    </div>
  );
};

export default React.memo(FooterColumnItem);
