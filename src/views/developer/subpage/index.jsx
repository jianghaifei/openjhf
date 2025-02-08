import React, { useEffect, useMemo } from "react";
import { useParams } from "react-router-dom";
import { connect } from "react-redux";
import DeveloperController from "../../../controllers/DeveloperController";
import GroupList from "../../../containers/developer/GroupList";
import ApplyRecord from "../../../containers/developer/ApplyRecord";
import Debug from "../../../containers/developer/Debug";
import DeveloperMessage from "../../../containers/developer/Message";
import DownloadSDK from "../../../containers/developer/DownloadSDK";
import { setMenuKey } from "../../../store/actions/Developer";

const { GROUP_LIST, APPLY_RECORD, DOWNLOAD_SDK, DEBUG, MESSAGE } = DeveloperController.MENU_KEY;
const { REQUEST, BILL, ORDER } = DEBUG;

const DeveloperSubPage = props => {
  const params = useParams();

  useEffect(() => {
    if (params.id) {
      props.setMenuKey(params?.id);
    }
    // eslint-disable-next-line
  }, [params?.id]);

  const renderComponent = useMemo(() => {
    switch (params?.id) {
      case APPLY_RECORD:
        return <ApplyRecord />;
      // case SIGNATURE:
      //   return <Signature />;
      // case DECODE:
      //   return <Decode />;
      case REQUEST:
      case BILL:
      case ORDER:
        return <Debug m={params.id} />;
      case MESSAGE:
        return <DeveloperMessage />;
      case DOWNLOAD_SDK:
        return <DownloadSDK />;
      case GROUP_LIST:
      default:
        return <GroupList />;
    }
  }, [params?.id]);

  return <div>{renderComponent}</div>;
};

const mapDispatchToProps = {
  setMenuKey
};
export default React.memo(
  connect(
    null,
    mapDispatchToProps
  )(DeveloperSubPage)
);
