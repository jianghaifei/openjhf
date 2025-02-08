import React from "react";
import "../css/HomePartnerItem.less";

const HomePartnerItem = props => {
  const { urlKey } = props;
  // eslint-disable-next-line global-require,import/no-dynamic-require
  const imageUrl = require(`../images/newPartner/logo${urlKey}.png`).default;
  return (
    <div className="partner-item">
      <img className="image" src={imageUrl} alt="partner" />
    </div>
  );
};

export default React.memo(HomePartnerItem);
