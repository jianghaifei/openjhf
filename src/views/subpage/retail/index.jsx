import React from "react";
import SubpageBanner from "../../../containers/subpage/components/SubpageBanner";
import bgImg from "../../../containers/home/images/solution/img2.jpg";
import SubpageScenario from "../../../containers/subpage/components/SubpageScenario";
import RetailController from "../../../controllers/subpage/RetailController";

const SubpageRetail = () => {
  const subtitles = ["多级的商品分类，满足除餐饮外的零售业务，强大的接口分类满足不同业务客户。"];

  const scenario1 = RetailController.getScenario1();
  const scenario2 = RetailController.getScenario2();
  return (
    <div className="subpage">
      <SubpageBanner bgImg={bgImg} title="零售业务" subtitles={subtitles} />
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

export default React.memo(SubpageRetail);
