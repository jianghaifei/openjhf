import React from "react";
import "../css/HomeEnter.less";
import ScrollAnim from "rc-scroll-anim";
import TweenOne from "rc-tween-one";
import QueueAnim from "rc-queue-anim";
import { ReactComponent as Enter1 } from "../../../assets/resto/enter1.svg";
import { ReactComponent as Enter2 } from "../../../assets/resto/enter2.svg";
import EnterBack1 from "../../../assets/resto/enter_back1.png";
import EnterBack2 from "../../../assets/resto/enter_back2.png";

const ScrollOverPack = ScrollAnim.OverPack;
const HomeAdvantage = () => {
  const numbers = Array.from({ length: 100 }, (_, i) => i + 1);
  return (
    <div className="home-enter">
      <ScrollOverPack playScale={0.2}>
        <div className="title">
          <TweenOne className="tween-one" key="0" animation={{ opacity: 1 }}>
            开发者入驻
          </TweenOne>
        </div>
      </ScrollOverPack>
      <div className="tab_item_box">
        <div className="icon1"> </div>
        <div className="icon2"> </div>
        <div className="icon3"> </div>
        <div className="icon4">
          {numbers.map((el, index) => (
            <span key={index}> </span>
          ))}
        </div>
        <ScrollOverPack playScale={0.2}>
          <dl>
            <dd>
              <QueueAnim key="1" type="left">
                <h1 key="1">
                  <Enter1 />
                </h1>
                <h2 key="2">独立开发服务商</h2>
                <p key="3">成为Resto技术合作伙伴</p>
                <p key="4">为众多商户/品牌提供开发服务。</p>
                <h3 key="5">
                  <span>加入</span>
                </h3>
              </QueueAnim>
            </dd>
            <dt
              style={{
                margin: "0 0 0 77px"
              }}
            >
              <QueueAnim key="1" type="right">
                <img src={EnterBack1} alt="" key="1" />
              </QueueAnim>
            </dt>
          </dl>
        </ScrollOverPack>
        <ScrollOverPack playScale={0.4} scrollDelay={5000}>
          <dl>
            <dt>
              <QueueAnim key="1" type="left" delay={100}>
                <img src={EnterBack2} alt="" key="4" />
              </QueueAnim>
            </dt>
            <dd
              style={{
                margin: "0 0 0 77px"
              }}
            >
              <QueueAnim key="1" type="right" delay={200}>
                <h1
                  style={{
                    margin: "40px 0 0 0"
                  }}
                  key="1"
                >
                  <Enter2 />
                </h1>
                <h2 key="2">品牌开发者</h2>
                <p key="3">商户开发者或受托开发者注册通道</p>
                <h3 key="4">
                  <span>加入</span>
                </h3>
              </QueueAnim>
            </dd>
          </dl>
        </ScrollOverPack>
      </div>
    </div>
  );
};

export default React.memo(HomeAdvantage);
