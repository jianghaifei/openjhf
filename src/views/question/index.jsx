import React, { useCallback, useEffect, useMemo, useState } from "react";
import { Menu, Spin, Tooltip } from "antd";
import { Link, Route, Switch } from "react-router-dom";
import { connect } from "react-redux";
import CommonSidebar from "../../components/layout/CommonSidebar";
import BreadcrumbController from "../../controllers/BreadcrumbController";
import QuestionDetail from "./detail";
import QuestionVerticalList from "./list";
import ResourceMenuService from "../../services/resource/ResourceMenuService";
import { setBreadcrumbs } from "../../store/actions/Question";
import "./index.less";

// const { Search } = Input;

const Question = props => {
  const { menuKey } = props;
  const [items, updateItems] = useState([]);
  const [loading, updateLoading] = useState(false);

  const getItems = useCallback(() => {
    updateLoading(true);
    ResourceMenuService.index(3)
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
    getItems();
  }, [getItems]);

  const setActiveMenu = useCallback(() => {
    BreadcrumbController.findBreadcrumb(items, menuKey, [{ text: "帮助中心" }]).then(result => {
      props.setBreadcrumbs(result);
    });
    // eslint-disable-next-line
  }, [items, menuKey]);

  useEffect(() => {
    if (menuKey) setActiveMenu();
  }, [menuKey, setActiveMenu]);

  const renderSidebar = useMemo(() => {
    const textMaxLength = 6;
    return items.map(item => {
      const { menuName, id } = item;
      return (
        <Menu.Item key={id} className="first-menu">
          <Link to={`/question/${id}`}>{menuName.length > textMaxLength ? <Tooltip title={menuName}>{menuName}</Tooltip> : menuName}</Link>
        </Menu.Item>
      );
    });
  }, [items]);

  // getSearchValue = value => {
  //   if (value) window.history.pushState({}, 0, `/question/vertical?type=search&keywords=${value}`);
  //   this.setState({
  //     pageType: "search",
  //     curMenuId: null,
  //     breadcrumbs: []
  //   });
  // };

  return (
    <Spin spinning={loading}>
      <div className="question-list-container">
        <CommonSidebar title="帮助中心">
          {/* <Search className="search-bar" placeholder="搜索" allowClear /> */}
          <Menu mode="inline" selectedKeys={[menuKey]}>
            {renderSidebar}
          </Menu>
        </CommonSidebar>
        <div className="right-container">
          <Switch>
            <Route exact path="/question/:id" component={QuestionVerticalList} />
            <Route exact path="/question/detail/:id" component={QuestionDetail} />
          </Switch>
        </div>
      </div>
    </Spin>
  );
};
const mapStateToProps = state => {
  return {
    menuKey: state.question.get("menuKey")
  };
};
const mapDispatchToProps = {
  setBreadcrumbs
};
export default React.memo(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(Question)
);
