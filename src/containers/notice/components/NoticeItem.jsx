import React, { useEffect, useState } from "react";
import { withRouter, Link } from "react-router-dom";
import { filterUrlQuery, timeFormat } from "../../../utils/utils";
import "../css/NoticeItem.less";

const NoticeItem = props => {
  const { msgTitle, publishTime, modifyTime, id } = props;
  const [menuId, updateMenuId] = useState();
  useEffect(() => {
    const { menuid = "-1" } = filterUrlQuery(props);
    updateMenuId(menuid);
  }, [props]);
  return (
    <Link className="notice-item" to={`/notice?detailid=${id}&menuid=${menuId}`}>
      <div className="title">{msgTitle}</div>
      <div className="time">{timeFormat(modifyTime || publishTime)}</div>
    </Link>
  );
};

export default withRouter(React.memo(NoticeItem));
