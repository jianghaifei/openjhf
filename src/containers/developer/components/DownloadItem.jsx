import React from "react";
import "../css/DownloadItem.less";

const DownloadItem = props => {
  const { title, link } = props;

  const handleDownClick = () => {
    window.open(link);
  };
  return (
    <div className="download-item">
      <div className="title">{title}</div>
      <div className="btn" onClick={handleDownClick}>
        点击前往
      </div>
    </div>
  );
};

export default React.memo(DownloadItem);
