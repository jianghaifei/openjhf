import React, { useState } from "react";
import CommonTitleBar from "../mobile-components/CommonTitleBar";
import MobileAdvantageTab from "./advantage/MobileAdvantageTab";
import icon1 from "../containers/home/images/advantage/icon1.png";
import icon2 from "../containers/home/images/advantage/icon2.png";
import icon3 from "../containers/home/images/advantage/icon3.png";
import icon4 from "../containers/home/images/advantage/icon4.png";
import MobileAdvantageContent1 from "./advantage/MobileAdvantageContent1";
import MobileAdvantageContent2 from "./advantage/MobileAdvantageContent2";
import MobileAdvantageContent3 from "./advantage/MobileAdvantageContent3";
import MobileAdvantageContent4 from "./advantage/MobileAdvantageContent4";

const MobileAdvantage = () => {
  const title = "平台优势&开放能力";
  const subtitle = "专注智能餐饮领域 打造开放共赢产业生态";
  const tabs = [
    {
      icon: icon1,
      text: "丰富的API",
      content: <MobileAdvantageContent1 />
    },
    {
      icon: icon2,
      text: "业务深度",
      content: <MobileAdvantageContent2 />
    },
    {
      icon: icon3,
      text: "数据安全",
      content: <MobileAdvantageContent3 />
    },
    {
      icon: icon4,
      text: "技术支持",
      content: <MobileAdvantageContent4 />
    }
  ];

  const [currentTab, updateCurrentTab] = useState(0);
  return (
    <>
      <CommonTitleBar title={title} subtitle={subtitle} />
      <MobileAdvantageTab currentTab={currentTab} items={tabs} onChange={tab => updateCurrentTab(tab)} />
      {tabs[currentTab].content}
    </>
  );
};

export default React.memo(MobileAdvantage);
