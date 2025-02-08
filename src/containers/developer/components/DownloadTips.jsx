import React from "react";
import "../css/DownloadTips.less";
import imgUrl from "../images/download_sdk/tips.png";

const DownloadTips = () => {
  return (
    <div className="download-tips">
      <img className="image" src={imgUrl} alt="tips" />
      <div className="title">其他开发语言版本正在努力研发中，敬请期待！</div>
    </div>
  );
};

export default React.memo(DownloadTips);
