import React, { useCallback, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { connect } from "react-redux";
import { Spin } from "antd";
import QuestionItem from "../../../containers/question/components/QuestionItem";
import { setMenuKey } from "../../../store/actions/Question";
import CommonContent from "../../../components/layout/CommonContent";
import ResourceService from "../../../services/resource/ResourceService";
import NoData from "../../../components/general/NoData";
import CommonBreadcrumb from "../../../components/general/CommonBreadcrumb";

const QuestionList = props => {
  const { breadcrumbs } = props;
  const params = useParams();
  const [items, updateItems] = useState([]);
  const [loading, updateLoading] = useState(false);
  const getItems = useCallback(id => {
    updateLoading(true);
    ResourceService.index(id, 0)
      .then(res => {
        const { code, result } = res;
        if (code !== "000") return false;
        updateItems(result);
      })
      .finally(() => {
        updateLoading(false);
      });
  }, []);

  useEffect(() => {
    if (params.id) {
      props.setMenuKey(params.id);
      getItems(params.id);
    }
    // eslint-disable-next-line
  }, [getItems, params.id]);

  return (
    <>
      <CommonBreadcrumb items={breadcrumbs} />
      <CommonContent extraHeight={20} style={{ overflowY: "auto" }}>
        <Spin spinning={loading}>
          {items.length ? (
            items.map(item => {
              return <QuestionItem {...item} parentId={params?.id} key={item.id} />;
            })
          ) : (
            <NoData />
          )}
        </Spin>
      </CommonContent>
    </>
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
  )(QuestionList)
);
