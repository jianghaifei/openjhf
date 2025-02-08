import React from "react";
import "../css/MobilePartnerItem.less";

const MobilePartnerItem = props => {
  const { imageNum } = props;
  // eslint-disable-next-line global-require,import/no-dynamic-require
  const imageUrl = require(`../../containers/home/images/partner/logo${imageNum}.png`).default;
  return (
    <div className="mobile-partner-item">
      <img src={imageUrl} alt="partner-item" />
    </div>
  );
};
export default React.memo(MobilePartnerItem);
