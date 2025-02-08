import React, { PureComponent } from "react";
import { withRouter } from "react-router-dom";
import { Carousel } from "react-responsive-carousel";
import BannerItem from "./components/HomeBannerItem";
import banner1 from "./images/banner/banner1.jpg";
// import banner2 from "./images/banner/banner2.jpg";
// import banner3 from "./images/banner/banner3.jpg";
import NavigationController from "../../controllers/NavigationController";
import "react-responsive-carousel/lib/styles/carousel.min.css";
import "./css/HomeBanner.less";

class HomeBanner extends PureComponent {
  state = {
    items: [
      {
        imgUrl: banner1,
        title: "互通互联 • 开放共赢",
        subTitle: "RESTO 开发者平台",
        test: "快速集成，简化流程，方便连接顾客、商家与平台",
        root: "resource"
      }
      // {
      //   imgUrl: banner2,
      //   title: "一站式餐饮解决方案",
      //   title1: "尽在Resto ",
      //   root: "resource",
      //   linkKey: "CODE_SCANNING_ORDER",
      //   isResourceId: true
      // },
      // {
      //   imgUrl: banner3,
      //   title: "助力商家",
      //   title1: "系统深度对接开放共赢",
      //   root: "resource",
      //   linkKey: "SETTLEMENT_PROCESS",
      //   isResourceId: true
      // }
    ]
  };

  pushToPage = item => {
    const { history } = this.props;
    const targetUrl = NavigationController.getTargetUrl(item);

    NavigationController.filterRouter(history, targetUrl);
  };

  render() {
    const { items } = this.state;
    return (
      <div className="home-banner">
        <div className="icon1"> </div>
        <Carousel
          // autoPlay
          axis="horizontal"
          showStatus={false}
          showThumbs={false}
          infiniteLoop
          interval={3000}
          emulateTouch
          showArrows={false}
          showIndicators
        >
          {items.map((item, index) => {
            return <BannerItem key={index} item={item} pushToPage={this.pushToPage} />;
          })}
        </Carousel>
      </div>
    );
  }
}

export default withRouter(HomeBanner);
