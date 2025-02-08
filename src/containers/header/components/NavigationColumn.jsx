import React from "react";
import { withRouter } from "react-router-dom";
import NavigationColumnItem from "./NavigationColumnItem";
import NavigationController from "../../../controllers/NavigationController";
import "../css/NavigationColumn.less";

const NavigationColumn = props => {
  const { title, root, linkKey, index: columnIndex, children: items = [], history, changeNavigationVisible } = props;

  const pushToPage = item => {
    const { root: targetRoot, linkKey: targetLinkKey, isResourceId = false } = item;
    if (!targetRoot) return false;
    const targetUrl = NavigationController.getTargetUrl({ root: targetRoot, linkKey: targetLinkKey, isResourceId });
    changeNavigationVisible(false);
    NavigationController.filterRouter(history, targetUrl);
  };

  return (
    <div className="navigation-column">
      <div className="title" onClick={() => pushToPage({ root, linkKey })}>
        {title}
      </div>
      {items.map((item, index) => {
        return <NavigationColumnItem {...item} pushToPage={() => pushToPage(item)} key={index} />;
      })}
      {columnIndex === 6 ? <div className="navigation-line" /> : null}
    </div>
  );
};
export default withRouter(React.memo(NavigationColumn));
