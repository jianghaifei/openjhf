import React, { useState } from "react";
import CommonTitleBar from "../mobile-components/CommonTitleBar";
import MobileSolutionTab from "./solution/MobileSolutionTab";
import "./css/MobileSolution.less";
import MobileSolutionCommonContent from "./solution/MobileSolutionCommonContent";
import MobileSolutionController from "../controllers/MobileSolutionController";

const MobileSolution = () => {
  const title = "业务解决方案";
  const subtitle = "覆盖多种业务场景 实现创新产品快速落地";
  const tabs = ["外卖业务", "到店餐饮", "零售业务", "聚合配送", "支付业务", "数据报表"];
  const titleStyle = {
    color: "#fff"
  };
  const subtitleStyle = {
    color: "#B1B1B1"
  };
  const [currentTab, updateCurrentTab] = useState(0);
  return (
    <div className="mobile-solution">
      <CommonTitleBar title={title} titleStyle={titleStyle} subtitle={subtitle} subtitleStyle={subtitleStyle} />
      <MobileSolutionTab currentTab={currentTab} items={tabs} onChange={tab => updateCurrentTab(tab)} />
      {MobileSolutionController.getSolution(currentTab) ? (
        <MobileSolutionCommonContent {...MobileSolutionController.getSolution(currentTab)} />
      ) : null}
    </div>
  );
};

export default React.memo(MobileSolution);
