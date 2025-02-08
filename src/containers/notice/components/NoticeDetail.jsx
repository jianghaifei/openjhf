import React, { useEffect, useState } from "react";
import NoticeService from "../../../services/notice/NoticeService";
import { timeFormat } from "../../../utils/utils";
import NoData from "../../../components/general/NoData";
import TinymceEditor from "../../../components/general/TinymceEditor";
import "../css/NoticeDetail.less";

const NoticeDetail = props => {
  const { id } = props;
  const [item, updateItem] = useState({});
  useEffect(() => {
    // 获取公告详情
    const getItem = () => {
      if (!id) return false;
      NoticeService.show({ id }).then(res => {
        const { code, result = {} } = res;
        if (code !== "000") return false;
        updateItem(result);
      });
    };
    getItem();
  }, [id]);

  const { msgTitle, publishTime, createTime, msgContent } = item;
  return (
    <div className="notice-detail">
      <div className="detail-title">{msgTitle}</div>
      <div className="detail-time">更新时间 :{timeFormat(publishTime || createTime)}</div>
      {msgContent ? <TinymceEditor isEdit={false} content={msgContent} /> : <NoData />}
    </div>
  );
};

export default React.memo(NoticeDetail);
