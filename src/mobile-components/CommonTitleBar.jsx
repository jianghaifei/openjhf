import React from "react";
import "./css/CommonTitleBar.less";

const CommonTitleBar = props => {
  const { title, subtitle, titleStyle = {}, subtitleStyle = {} } = props;
  return (
    <div className="mobile-common-title-bar">
      <div className="title" style={titleStyle}>
        {title}
      </div>
      {subtitle ? (
        <div className="subtitle" style={subtitleStyle}>
          {subtitle}
        </div>
      ) : null}
    </div>
  );
};

export default React.memo(CommonTitleBar);
