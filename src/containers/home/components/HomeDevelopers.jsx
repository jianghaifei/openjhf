import React, { useState } from "react";
import "../css/HomeDevelopers.less";
import ScrollAnim from "rc-scroll-anim";
import TweenOne from "rc-tween-one";
import QueueAnim from "rc-queue-anim";
import { ReactComponent as Develop2 } from "../../../assets/resto/develop2.svg";
import { ReactComponent as Develop3 } from "../../../assets/resto/develop3.svg";
import { ReactComponent as Develop1 } from "../../../assets/resto/develop1.svg";

const ScrollOverPack = ScrollAnim.OverPack;
const HomeAdvantage = () => {
  const [items] = useState([
    {
      icon: <Develop1 />,
      text: "一站式集成",
      descript1: "不仅是开放平台",
      descript2: "更是业务集成中心"
    },
    {
      icon: <Develop2 />,
      text: "成熟方案",
      descript1: "覆盖多种业务场景",
      descript2: "实现产品方案快速落地"
    },
    {
      icon: <Develop3 />,
      text: "全球运营",
      descript1: "在Resto套件，管理你的全球餐厅",
      descript2: "在Resto开发者平台，接入您的全球数据"
    }
  ]);

  const getTabItemInfo = index => {
    const { text, descript1, descript2, icon } = items[index - 1];
    return (
      <div className="ntab-item" key={index}>
        {icon}
        <h1 className="text">{text}</h1>
        <p>{descript1}</p>
        <p>{descript2}</p>
      </div>
    );
  };

  return (
    <ScrollOverPack id="page1" playScale={0.1}>
      <div className="home-developers">
        <div className="title">
          <TweenOne className="tween-one" key="0" animation={{ opacity: 1 }}>
            开发者的Resto
          </TweenOne>
        </div>

        <div className="tab_item_box">
          <QueueAnim key="1">
            {items.map((el, index) => {
              return getTabItemInfo(index + 1);
            })}
          </QueueAnim>
        </div>
      </div>
    </ScrollOverPack>
  );
};

export default React.memo(HomeAdvantage);
