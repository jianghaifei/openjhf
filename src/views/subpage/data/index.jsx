import React from "react";
import SubpageBanner from "../../../containers/subpage/components/SubpageBanner";
import bgImg from "../../../containers/home/images/solution/img5.jpg";
import SubpageScenario from "../../../containers/subpage/components/SubpageScenario";
import DataController from "../../../controllers/subpage/DataController";

const SubpageData = () => {
  const subtitles = ["门店账单实时推送，历史账单数据一键拉取，与Resto 报表中心打通，支持多维度的数据报表查询。"];
  const scenario1 = DataController.getScenario1();
  const scenario2 = DataController.getScenario2();
  const scenario3 = DataController.getScenario3();
  const scenario4 = DataController.getScenario4();

  return (
    <div className="subpage">
      <SubpageBanner bgImg={bgImg} title="数据报表" subtitles={subtitles} />
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

export default React.memo(SubpageData);
