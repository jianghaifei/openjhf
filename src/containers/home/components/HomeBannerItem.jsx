import React from "react";
import "../css/HomeBannerItem.less";

const HomeBannerItem = props => {
  const { pushToPage, item } = props;
  const { title, title1, subTitle, test } = item;

  return (
    <div className="banner-item">
      {/* <img className="image" src={imgUrl} alt={title} /> */}
      <div className="banner-content">
        <div className="title1">{title || null}</div>
        <div className="title2">{title1 || null}</div>
        {subTitle ? <div className="sub-title">{subTitle}</div> : null}
        {test ? <p>{test}</p> : ""}
        <div className="btn" onClick={() => pushToPage(item)}>
          开始
        </div>
      </div>
    </div>
  );
};

export default React.memo(HomeBannerItem);
