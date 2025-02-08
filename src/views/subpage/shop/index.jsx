import React from "react";
import SubpageBanner from "../../../containers/subpage/components/SubpageBanner";
import bgImg from "../../../containers/home/images/solution/img1.jpg";
import SubpageScenario from "../../../containers/subpage/components/SubpageScenario";
import ShopController from "../../../controllers/subpage/ShopController";

const SubpageShop = () => {
  const subtitles = ["提供强大的商户在线营销能力，为商户提供品牌建设传播和引客到店消费服务。"];

  const scenario1 = ShopController.getScenario1();
  const scenario2 = ShopController.getScenario2();
  const scenario3 = ShopController.getScenario3();
  const scenario4 = ShopController.getScenario4();
  return (
    <div className="subpage">
      <SubpageBanner bgImg={bgImg} title="到店餐饮" subtitles={subtitles} />
      <div className="scenario-item">
        <div className="title">业务场景介绍</div>
        <div className="desc">为您的业务带来更广阔的便利场景</div>
        <SubpageScenario {...scenario1} styles={{ marginTop: "80px" }} />
      </div>
      <div className="scenario-item gray-background" style={{ padding: "110px 0" }}>
        <SubpageScenario {...scenario2} imgIsLeft={false} />
      </div>
      <div className="scenario-item">
        <SubpageScenario {...scenario3} styles={{ marginTop: "80px" }} />
      </div>
      <div className="scenario-item gray-background" style={{ padding: "110px 0" }}>
        <SubpageScenario {...scenario4} imgIsLeft={false} />
      </div>
    </div>
  );
};

export default React.memo(SubpageShop);
