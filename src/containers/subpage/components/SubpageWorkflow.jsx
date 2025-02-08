import React from "react";
import "../css/SubpageWorkflow.less";
import arrow from "../images/workflow/arrow.png";
import img1 from "../images/workflow/1.png";
import img2 from "../images/workflow/2.png";
import img3 from "../images/workflow/3.png";
import img4 from "../images/workflow/4.png";

const SubpageWorkflow = () => {
  return (
    <div className="subpage-workflow">
      <div className="title">接入流程</div>
      <div className="subtitle">快捷入驻，降低平台用户理解成本</div>
      <div className="content-container">
        <img className="step-img" src={img1} alt="img1" />
        <img className="arrow-img" src={arrow} alt="arrow" />
        <img className="step-img" src={img2} alt="img2" />
        <img className="arrow-img" src={arrow} alt="arrow" />
        <img className="step-img" src={img3} alt="img3" />
        <img className="arrow-img" src={arrow} alt="arrow" />
        <img className="step-img" src={img4} alt="img4" />
      </div>
    </div>
  );
};
export default React.memo(SubpageWorkflow);
