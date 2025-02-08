import React from "react";
import "../css/MobileAdvantageCommonContent.less";

const MobileAdvantageCommonContent = props => {
  const { imageUrl, children } = props;
  return (
    <div className="mobile-advantage-common-content">
      <div className="image-box">
        <img src={imageUrl} alt="left-info" />
      </div>
      <div className="container">{children}</div>
    </div>
  );
};
export default React.memo(MobileAdvantageCommonContent);
