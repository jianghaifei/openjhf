import React from "react";
import "../css/SubpageBanner.less";

const SubpageBanner = props => {
  const { bgImg, title, subtitles } = props;
  return (
    <div className="subpage-banner" style={{ backgroundImage: `url(${bgImg})` }}>
      <div className="banner-content-container">
        <div className="title">{title}</div>
        {subtitles.map((item, index) => {
          return (
            <div className="subtitle" key={index}>
              {item}
            </div>
          );
        })}
      </div>
    </div>
  );
};
export default React.memo(SubpageBanner);
