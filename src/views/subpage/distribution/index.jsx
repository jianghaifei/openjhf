import React from "react";
import SubpageBanner from "../../../containers/subpage/components/SubpageBanner";
import bgImg from "../../../containers/home/images/solution/img3.jpg";
import SubpageScenario from "../../../containers/subpage/components/SubpageScenario";
import DistributionController from "../../../controllers/subpage/DistributionController";

const SubpageDistribution = () => {
  const subtitles = ["聚合多种配送平台，系统自动接单智能分配优质的配送平台，满足多种配送需求。"];
  const scenario1 = DistributionController.getScenario1();
  return (
    <div className="subpage">
      <SubpageBanner bgImg={bgImg} title="聚合配送" subtitles={subtitles} />
      <div className="scenario-item">
        <div className="title">业务场景介绍</div>
        <div className="desc">为您的业务带来更广阔的便利场景</div>
        <SubpageScenario {...scenario1} styles={{ marginTop: "80px" }} />
      </div>
    </div>
  );
};

export default React.memo(SubpageDistribution);
