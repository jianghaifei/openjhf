import React from "react";
import ScrollAnim from "rc-scroll-anim";
import HomeBanner from "../../containers/home/HomeBanner";
// import HomePartner from "../../containers/home/components/HomePartner";
import OpenApiFooter from "../../containers/footer";
import HomeDevelopers from "../../containers/home/components/HomeDevelopers";
import HomeIntegration from "../../containers/home/components/HomeIntegration";
import HomeEnter from "../../containers/home/components/HomeEnter";

import "./index.less";

const ScrollOverPack = ScrollAnim.OverPack;
const Home = () => {
  return (
    <div className="home-index">
      
      <div className="top-content">
        <HomeBanner />
      </div>
      <HomeDevelopers />

      <HomeIntegration />

      <HomeEnter />

      <ScrollOverPack id="page5" className="page1">
        <OpenApiFooter />
      </ScrollOverPack>

      {/* <HomePartner /> */}
    </div>
  );
};

export default React.memo(Home);
