import React, { PureComponent } from "react";
import { withRouter } from "react-router-dom";
import QueueAnim from "rc-queue-anim";
import LogoIcon from "./components/logoIcon/index";
import "react-responsive-carousel/lib/styles/carousel.min.css";
import "./css/HomeBanner.less";
import "./css/HomeBannerItem.less";

class HomeBanner extends PureComponent {
  render() {
    return (
      <div className="home-banner">
        <div className="icon1"> </div>

        <div className="banner-item">
          <div className="banner-content">
            <QueueAnim key="1">
              <div className="title1" key="1">
                互通互联 • 开放共赢
              </div>
              <div className="sub-title" key="2">
                RESTO 开发者平台
              </div>
              <p key="3">快速集成，简化流程，方便连接顾客、商家与平台</p>
            </QueueAnim>
          </div>
        </div>
        <div className="bynbox">
          <div>
            <a className="btn" key="4" href="/resource/1871491721938923525">
              开始
            </a>
          </div>
        </div>
        <div className="icon2">
          <LogoIcon />
        </div>
      </div>
    );
  }
}

export default withRouter(HomeBanner);
