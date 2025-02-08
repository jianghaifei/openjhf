import React from "react";
import FooterColumnItem from "./FooterColumnItem";
import "../css/FooterColumn.less";

const FooterColumn = props => {
  const { title, items, pushToPage } = props;
  return (
    <div className="footer-column">
      <div className="title">{title}</div>
      {items.map((item, index) => {
        return <FooterColumnItem {...item} pushToPage={() => pushToPage(item)} key={index} />;
      })}
    </div>
  );
};
export default React.memo(FooterColumn);
