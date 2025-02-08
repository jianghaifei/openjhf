import React from "react";
import { withRouter } from "react-router-dom";
import SubpageScenarioInfoTitle from "./SubpageScenarioInfoTitle";
import SubpageScenarioServiceItem from "./SubpageScenarioServiceItem";
// import SubpageScenarioCaseItem from "./SubpageScenarioCaseItem";
import NavigationController from "../../../controllers/NavigationController";
import "../css/SubpageScenario.less";

const SubpageScenario = props => {
  const { imgUrl, title, desc, styles = {}, imgIsLeft = true, serviceInfo = {} } = props;
  // const { imgUrl, title, desc, styles = {}, imgIsLeft = true, serviceInfo = {}, caseInfo = {} } = props;
  const { title: serviceTitle, items: serviceIcons } = serviceInfo;
  // const { title: caseTitle, items: caseIcons } = caseInfo;
  const pushToPage = () => {
    const { history, link } = props;
    if (!link) return false;
    const targetUrl = NavigationController.getTargetUrl({ root: "resource", linkKey: link, isResourceId: true });
    NavigationController.filterRouter(history, targetUrl);
  };
  return (
    <div className="subpage-scenario" style={{ flexDirection: imgIsLeft ? "row" : "row-reverse", ...styles }}>
      <img className="image" src={imgUrl} alt="scenario-img" />
      <div className="info" style={{ margin: `${imgIsLeft ? "0 0 0 -40px" : "0 -40px 0 0"}` }}>
        <div className="title">{title}</div>
        <div className="desc">{desc}</div>

        <div className="service-info sub-info">
          <SubpageScenarioInfoTitle title={serviceTitle} />
          <div className="sub-info-container">
            {serviceIcons.map((item, index) => {
              return <SubpageScenarioServiceItem {...item} key={index} />;
            })}
          </div>
        </div>
        {/* <div className="sub-info"> */}
        {/*	<SubpageScenarioInfoTitle title={caseTitle} /> */}
        {/*	<div className="sub-info-container"> */}
        {/*		{caseIcons.map((item, index) => { */}
        {/*			return <SubpageScenarioCaseItem icon={item} key={index} />; */}
        {/*		})} */}
        {/*	</div> */}
        {/* </div> */}
        <div className="btn" onClick={pushToPage}>
          查看方案详情
        </div>
      </div>
    </div>
  );
};

export default withRouter(React.memo(SubpageScenario));
