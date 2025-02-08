import React from "react";
import "../css/MobileSolutionCommonContent.less";

const MobileSolutionCommonContent = props => {
  const { imageUrl, desc, tags } = props;
  return (
    <div className="mobile-solution-common-content">
      <img className="banner" src={imageUrl} alt="banner" />
      <div className="desc">{desc}</div>
      <div className={`container ${tags.length === 2 ? "tag-center" : ""}`}>
        {tags.map((item, index) => {
          return (
            <div className="tag" key={index}>
              {item}
            </div>
          );
        })}
      </div>
    </div>
  );
};
export default React.memo(MobileSolutionCommonContent);
