import React, { useEffect, useState } from "react";
import NoticeItem from "./NoticeItem";
import NoticeService from "../../../services/notice/NoticeService";
import NoData from "../../../components/general/NoData";
import "../css/NoticeList.less";
import CommonBackTop from "../../../components/general/CommonBackTop";

const NoticeList = props => {
  const { id } = props;
  const [items, updateItems] = useState([]);

  useEffect(() => {
    const getItems = () => {
      NoticeService.index({ msgType: id, isPublish: 1 }).then(res => {
        const { code, result } = res;
        if (code !== "000") return false;
        updateItems(result.list || []);
      });
    };

    const getAllNotice = () => {
      NoticeService.index({ isGetAllMsg: 1, isPublish: 1 }).then(res => {
        const { code, result } = res;
        if (code !== "000") return false;
        updateItems(result.list || []);
      });
    };
    if (Number(id) !== -1) {
      getItems();
    } else {
      getAllNotice();
    }
  }, [id]);

  return (
    <div className="notice-list" id="noticeList">
      {items.length > 0 ? (
        items.map((item, index) => {
          return <NoticeItem {...item} key={index} />;
        })
      ) : (
        <NoData />
      )}
      <CommonBackTop target={() => document.getElementById("noticeList")} />
    </div>
  );
};

export default React.memo(NoticeList);
