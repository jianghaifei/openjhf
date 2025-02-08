import React, { useState } from "react";
import ScrollAnim from "rc-scroll-anim";
import TweenOne from "rc-tween-one";
import QueueAnim from "rc-queue-anim";
import "../css/HomeIntegration.less";

import { ReactComponent as Integration1 } from "../../../assets/resto/integration1.svg";
import { ReactComponent as Integration2 } from "../../../assets/resto/integration2.svg";
import { ReactComponent as Integration3 } from "../../../assets/resto/integration3.svg";
import { ReactComponent as Integration4 } from "../../../assets/resto/integration4.svg";
import { ReactComponent as Integration5 } from "../../../assets/resto/integration5.svg";
import { ReactComponent as Integration6 } from "../../../assets/resto/integration6.svg";
import { ReactComponent as Integration7 } from "../../../assets/resto/integration7.svg";
import { ReactComponent as Integration8 } from "../../../assets/resto/integration8.svg";
import { ReactComponent as Integration9 } from "../../../assets/resto/integration9.svg";

const ScrollOverPack = ScrollAnim.OverPack;
const HomeAdvantage = () => {
  const [status, setStatus] = useState(1);
  const [items] = useState([
    [
      {
        icon: <Integration1 />,
        text: "开始",
        descript1: (
          <div>
            <p>启航！</p>
            <p>从这里开始你的集成开发</p>
          </div>
        )
      },
      {
        icon: <Integration2 />,
        text: "门店",
        link: "/resource/f09ed01396349d1e310bedb353f4a026",
        descript1: (
          <div>
            <p>获取门店信息与档案</p>
            <p>设置门店</p>
            <p>创建门店</p>
          </div>
        )
      },
      {
        icon: <Integration3 />,
        text: "菜单",
        link: "/resource/fa4c32763f56b92bd751899e4bf3d66c",
        descript1: (
          <div>
            <p>获取商品</p>
            <p>设置门店菜单</p>
            <p>同步三方菜单</p>
          </div>
        )
      },
      {
        icon: <Integration4 />,
        text: "库存",
        link: "/resource/d53ec97f295948600e336d1c89735b43",
        descript1: (
          <div>
            <p>获取门店销售库存</p>
            <p>接受库存变更推送</p>
            <p>同意库存管理</p>
          </div>
        )
      }
    ],
    [
      {
        icon: <Integration5 />,
        text: "订单",
        link: "/resource/2a94652f2b7fe6e6b80a04a82e3f92d0",
        descript1: (
          <div>
            <p>创建订单</p>
            <p>获取订单信息</p>
            <p>订单履约管理</p>
            <p>退款管理</p>
          </div>
        )
      },
      // {
      //   icon: <Integration6 />,
      //   link: "#",
      //   text: "支付",
      //   descript1: (
      //     <div>
      //       <p>支付直连介入</p>
      //       <p>支付账户管理</p>
      //       <p>发起订单支付</p>
      //       <p>发起退款</p>
      //     </div>
      //   )
      // },
      {
        icon: <Integration7 />,
        text: "报表",
        link: "#",
        descript1: (
          <div>
            <p>综合销售报告</p>
            <p>日结销售报告</p>
            <p>收款报告</p>
            <p>对账信息查询</p>
          </div>
        )
      },
      // {
      //   icon: <Integration8 />,
      //   text: "三方外卖",
      //   link: "#",
      //   descript1: (
      //     <div>
      //       <p>三方品牌自营介入</p>
      //       <p>订单同步</p>
      //       <p>配送同步</p>
      //       <p>退单退款管理</p>
      //       <p>外卖评价管理</p>
      //     </div>
      //   )
      // }
    ],
    // [
    //   // {
    //   //   icon: <Integration9 />,
    //   //   text: "会员",
    //   //   link: "#",
    //   //   descript1: (
    //   //     <div>
    //   //       <p>会员管理</p>
    //   //       <p>会员交易管理</p>
    //   //       <p>会员资产获取</p>
    //   //       <p>群体与标签管理</p>
    //   //     </div>
    //   //   )
    //   // }
    // ]
  ]);

  const getTabItemInfo = (el, index) => {
    const { text, descript1, descript2, icon } = el;
    return (
      <a
        className={`ntab-item ${status === index ? "active-item" : ""}`}
        key={index}
        onClick={() => {
          setStatus(index);
        }}
        onMouseMove={() => {
          setStatus(index);
        }}
        href={el.link}
      >
        <h2>{icon}</h2>
        <h1 className="text">{text}</h1>
        <div>{descript1}</div>
        <div>{descript2}</div>
      </a>
    );
  };

  return (
    <div className="home-integration">
      <div className="title">
        <TweenOne className="tween-one" key="0" animation={{ opacity: 1 }}>
          开始集成
        </TweenOne>
      </div>

      <div className="icon1"> </div>

      {items.map((item, key) => (
        <div className="tab_item_box" key={key}>
          <ScrollOverPack id="page2" playScale={0.2}>
            <QueueAnim key="1" type="bottom" delay={key * 200}>
              {item.map((el, index) => {
                return getTabItemInfo(el, 4 * key + 1 + index);
              })}
            </QueueAnim>
          </ScrollOverPack>
        </div>
      ))}
    </div>
  );
};

export default React.memo(HomeAdvantage);
