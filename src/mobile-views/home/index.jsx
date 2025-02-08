import React from "react";
import { Carousel } from "react-responsive-carousel";
import MobileAdvantage from "../../mobile-containers/MobileAdvantage";
import MobileSolution from "../../mobile-containers/MobileSolution";
import MobilePartner from "../../mobile-containers/MobilePartner";
import MobileData from "../../mobile-containers/MobileData";
import logo from "../../assets/images/logo1.png";
import banner1 from "../../assets/images/mobile/banner1.jpg";
import banner2 from "../../assets/images/mobile/banner2.jpg";
import banner3 from "../../assets/images/mobile/banner3.jpg";
import "react-responsive-carousel/lib/styles/carousel.min.css";
import "./index.less";

const MobileHome = () => {
  return (
    <div className="mobile-home-page">
      <div className="top-logo">
        <img src={logo} alt="logo" />
      </div>
      <Carousel
        className="banner-container"
        autoPlay
        axis="horizontal"
        showStatus={false}
        showThumbs={false}
        infiniteLoop
        interval={3000}
        emulateTouch
        showArrows={false}
        showIndicators={false}
      >
        <img src={banner1} alt="banner1" />
        <img src={banner2} alt="banner2" />
        <img src={banner3} alt="banner3" />
      </Carousel>
      <MobileAdvantage />
      <MobileSolution />
      <MobilePartner />
      <MobileData />
      <div className="bottom-logo">
        <img src={logo} alt="logo" />
      </div>
      <div className="tip-btn">详情请在电脑端查看</div>
    </div>
  );
};

export default React.memo(MobileHome);
