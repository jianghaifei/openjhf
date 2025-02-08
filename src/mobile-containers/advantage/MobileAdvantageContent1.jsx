import React from "react";
import contentImg1 from "../../containers/home/images/advantage/tab-item-img1.png";
import MobileAdvantageCommonContent from "./MobileAdvantageCommonContent";
import AdvantageController from "../../controllers/AdvantageController";
import "../css/MobileAdvantageContent1.less";

const MobileAdvantageContent1 = () => {
  const cardItems = AdvantageController.getCardItems("mobile");

  return (
    <div className="mobile-advantage-content1">
      <MobileAdvantageCommonContent imageUrl={contentImg1}>
        {cardItems.map((item, index) => {
          return (
            <div className="card-item" key={index}>
              <div className="card-title">{item.title}</div>
              <div className="card-desc">{item.desc}</div>
            </div>
          );
        })}
      </MobileAdvantageCommonContent>
    </div>
  );
};
export default React.memo(MobileAdvantageContent1);
