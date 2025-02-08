import React from "react";
import SubpageBanner from "../../../containers/subpage/components/SubpageBanner";
import bgImg from "../../../containers/home/images/solution/img0.jpg";
import SubpageScenario from "../../../containers/subpage/components/SubpageScenario";
import TakeoutController from "../../../controllers/subpage/TakeoutController";

const SubpageTakeout = () => {
  const subtitles = ["丰富的外卖类业务接口，开放多类业务场景模式，实现系统处理商家外卖业务的全部流程。"];

  const scenario1 = TakeoutController.getScenario1();
  // const scenario2 = TakeoutController.getScenario2();
  const scenario3 = TakeoutController.getScenario3();
  const scenario4 = TakeoutController.getScenario4();
  // const scenario5 = TakeoutController.getScenario5();
  const scenario6 = TakeoutController.getScenario6();
  return (
    <div className="subpage">
      <SubpageBanner bgImg={bgImg} title="外卖业务" subtitles={subtitles} />
      <div className="scenario-item">
        <div className="title">业务场景介绍</div>
        <div className="desc">为您的业务带来更广阔的便利场景</div>
        <SubpageScenario {...scenario1} styles={{ marginTop: "80px" }} />
      </div>
      {/* <div className="scenario-item gray-background" style={{ padding: "110px 0" }}> */}
      {/*	<SubpageScenario {...scenario2} imgIsLeft={false} /> */}
      {/* </div> */}
      <div className="scenario-item" style={{ padding: "90px 0" }}>
        <SubpageScenario {...scenario3} imgIsLeft={false} />
      </div>
      <div className="scenario-item gray-background" style={{ padding: "110px 0" }}>
        <SubpageScenario {...scenario4} />
      </div>
      {/* <div className="scenario-item" style={{ padding: "90px 0" }}> */}
      {/*	<SubpageScenario {...scenario5} /> */}
      {/* </div> */}
      <div className="scenario-item gray-background" style={{ padding: "110px 0" }}>
        <SubpageScenario {...scenario6} imgIsLeft={false} />
      </div>
    </div>
  );
};

export default React.memo(SubpageTakeout);
