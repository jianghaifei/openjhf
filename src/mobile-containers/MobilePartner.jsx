import React, { useEffect, useState } from "react";
import { Carousel } from "react-responsive-carousel";
import CommonTitleBar from "../mobile-components/CommonTitleBar";
import MobilePartnerItem from "./partner/MobilePartnerItem";
import "./css/MobilePartner.less";

const MobilePartner = () => {
  const title = "合作服务商&品牌";
  const subtitle = "携手合作伙伴 共建智能餐饮行业新生态";
  const imgCount = 108;
  const singlePageCount = 12; // 每页展示12条 3行4列
  const [imgItems, updateImgItems] = useState([]);
  const [autoplay, updateAutoplay] = useState(false);

  useEffect(() => {
    const imgPage = imgCount / singlePageCount;
    const setImagePage = () => {
      const parentArr = [];
      for (let i = 0; i < imgPage; i++) {
        const childrenArr = [];
        for (let j = i * singlePageCount; j < (i + 1) * singlePageCount; j++) {
          childrenArr.push(j);
        }
        parentArr.push(childrenArr);
      }
      updateImgItems(parentArr);
      updateAutoplay(true);
    };
    setImagePage();
  }, []);

  return (
    <div className="mobile-partner">
      <CommonTitleBar title={title} subtitle={subtitle} />
      <Carousel
        autoPlay={autoplay}
        axis="horizontal"
        showStatus={false}
        showThumbs={false}
        infiniteLoop
        interval={2000}
        emulateTouch={false}
        stopOnHover={false}
        swipeable={false}
        showArrows={false}
        showIndicators={false}
      >
        {imgItems.map((item, index) => {
          return (
            <div className="partner-page" key={index}>
              {item.map((subItem, subIndex) => {
                return <MobilePartnerItem imageNum={subItem} key={subIndex} />;
              })}
            </div>
          );
        })}
      </Carousel>
      <div className="partner-mask" />
    </div>
  );
};

export default React.memo(MobilePartner);
