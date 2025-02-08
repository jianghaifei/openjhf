import React from "react";
import SubpageBanner from "../../../containers/subpage/components/SubpageBanner";
import bgImg from "../../../containers/home/images/solution/img4.jpg";
import SubpageScenario from "../../../containers/subpage/components/SubpageScenario";
import PaymentController from "../../../controllers/subpage/PaymentController";

const SubpagePayment = () => {
  const subtitles = ["支持多样化支付场景，小程序支付、付款码支付、扫码支付，支付退款明细查询一应俱全。"];

  const scenario1 = PaymentController.getScenario1();
  const scenario2 = PaymentController.getScenario2();
  const scenario3 = PaymentController.getScenario3();
  return (
    <div className="subpage">
      <SubpageBanner bgImg={bgImg} title="支付业务" subtitles={subtitles} />
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
    </div>
  );
};

export default React.memo(SubpagePayment);
