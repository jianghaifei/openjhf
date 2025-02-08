import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useParams, useLocation } from "react-router-dom";
import { connect } from "react-redux";
import { Spin } from "antd";
import NoData from "../../../components/general/NoData";
import TinymceEditor from "../../../components/general/TinymceEditor";
import BraftEdit from "../../../components/general/BraftEdit";
import { setMenuKey } from "../../../store/actions/Question";
import { filterUrlQuery, timeFormat } from "../../../utils/utils";
import ResourceService from "../../../services/resource/ResourceService";
import CommonContent from "../../../components/layout/CommonContent";
import CommonBreadcrumb from "../../../components/general/CommonBreadcrumb";
import ResourceController from "../../../controllers/ResourceController";
import "./index.less";

const QuestionDetail = props => {
  const { breadcrumbs } = props;
  const { id } = useParams();
  const location = useLocation();
  const [item, updateItem] = useState(null);
  const [loading, updateLoading] = useState(false);

  const getItem = useCallback(() => {
    if (!id) return false;
    updateLoading(true);
    ResourceService.show(id, 3)
      .then(res => {
        const { code, result = {} } = res;
        if (code === "010103") {
          updateItem(null);
          return false;
        }
        if (code !== "000") return false;
        updateItem(result);
      })
      .finally(() => {
        updateLoading(false);
      });
  }, [id]);

  useEffect(() => {
    const { m } = filterUrlQuery({ location });
    if (m) props.setMenuKey(m);
    // eslint-disable-next-line
  }, [location]);

  useEffect(() => {
    getItem();
  }, [getItem]);

  const renderStringTitle = useMemo(() => ResourceController.renderStringTitle(item?.contentTitle), [item]);
  const renderElementTitle = useMemo(() => ResourceController.renderElementTitle(item?.contentTitle), [item]);
  const renderContent = useMemo(() => renderStringTitle + item?.content, [renderStringTitle, item]);
  const renderTime = useMemo(() => ResourceController.renderUpdateTime(timeFormat(item?.modifyTime)), [item]);
  return (
    <div className="question-detail">
      <CommonBreadcrumb items={[...breadcrumbs, { text: item?.contentTitle || "" }]} rightSlot={renderTime} />
      <CommonContent extraHeight={20}>
        <Spin spinning={loading}>
          {item?.content ? (
            Number(item.type) === 3 ? (
              <TinymceEditor content={renderContent} />
            ) : (
              <BraftEdit content={renderContent} />
            )
          ) : renderElementTitle ? (
            <>
              {renderElementTitle}
              <NoData />
            </>
          ) : (
            <NoData />
          )}
        </Spin>
      </CommonContent>
    </div>
  );
};

const mapStateToProps = state => {
  return {
    breadcrumbs: state.question.get("breadcrumbs").toJS()
  };
};
const mapDispatchToProps = {
  setMenuKey
};
export default React.memo(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(QuestionDetail)
);
