import React from "react";
import contentImg2 from "../../containers/home/images/advantage/tab-item-img2.png";
import MobileAdvantageCommonContent from "./MobileAdvantageCommonContent";
import "../css/MobileAdvantageContent2.less";

const MobileAdvantageContent2 = () => {
  const title = "覆盖全行业多种解决方案";
  const subtitles = [
    "通过标准化的API接口",
    "为企业根据场景需求定制",
    "全方位打通数据",
    "助力商家",
    "实现线上线下业务的一站式统一化管理",
    "提升业务运营能效"
  ];
  return (
    <div className="mobile-advantageContent2">
      <MobileAdvantageCommonContent imageUrl={contentImg2}>
        <div className="title">{title}</div>
        {subtitles.map((item, index) => {
          return (
            <div className="subtitle" key={index}>
              <div className="dot" />
              <span className="text">{item}</span>
            </div>
          );
        })}
      </MobileAdvantageCommonContent>
    </div>
  );
};
export default React.memo(MobileAdvantageContent2);
