import React from "react";
import contentImg from "../../containers/home/images/advantage/tab-item-img3.png";
import MobileAdvantageCommonContent from "./MobileAdvantageCommonContent";
import "../css/MobileAdvantageContent3.less";

const MobileAdvantageContent3 = () => {
  const title = "数据安全";
  const subtitle = "专业的运维团队";
  const subtitle1 = "平台数据安全的基础保障";
  return (
    <div className="mobile-advantageContent3">
      <MobileAdvantageCommonContent imageUrl={contentImg}>
        <div className="title">{title}</div>
        <div className="subtitle">{subtitle}</div>
        <div className="subtitle">{subtitle1}</div>
      </MobileAdvantageCommonContent>
    </div>
  );
};
export default React.memo(MobileAdvantageContent3);
