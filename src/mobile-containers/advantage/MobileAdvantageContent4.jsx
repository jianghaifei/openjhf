import React from "react";
import contentImg from "../../containers/home/images/advantage/tab-item-img4.png";
import MobileAdvantageCommonContent from "./MobileAdvantageCommonContent";
import "../css/MobileAdvantageContent4.less";

const MobileAdvantageContent4 = () => {
  const title = "全程技术人员协助";
  // const subtitle = "全程技术人员协助对接";
  const subtitle1 = "提供完整详细的API文档、SDK";
  const subtitle2 = "专业的技术人员全程协助对接";
  return (
    <div className="mobile-advantageContent4">
      <MobileAdvantageCommonContent imageUrl={contentImg}>
        <div className="title">{title}</div>
        {/* <div className="subtitle">{subtitle}</div> */}
        <div className="subtitle">{subtitle1}</div>
        <div className="subtitle">{subtitle2}</div>
      </MobileAdvantageCommonContent>
    </div>
  );
};
export default React.memo(MobileAdvantageContent4);
