import React from "react";
import SubpageBanner from "../../../containers/subpage/components/SubpageBanner";
import bgImg from "./images/banner.jpg";
import SubpageScenario from "../../../containers/subpage/components/SubpageScenario";
import MarketingController from "../../../controllers/subpage/MarketingController";

const SubpageMarketing = () => {
  const subtitles = [
    "联合共建会员池，构建一套以会员入会、会员成长、会员营销的餐饮行业会员营销解决方案，多样的营销活动，助力商家吸引更多会员。"
  ];

  const scenario1 = MarketingController.getScenario1();
  const scenario2 = MarketingController.getScenario2();
  return (
    <div className="subpage">
      <SubpageBanner bgImg={bgImg} title="会员营销" subtitles={subtitles} />
      <div className="scenario-item">
        <div className="title">业务场景介绍</div>
        <div className="desc">为您的业务带来更广阔的便利场景</div>
        <SubpageScenario {...scenario1} styles={{ marginTop: "80px" }} />
      </div>
      <div className="scenario-item gray-background" style={{ padding: "110px 0" }}>
        <SubpageScenario {...scenario2} imgIsLeft={false} />
      </div>
    </div>
  );
};

export default React.memo(SubpageMarketing);
