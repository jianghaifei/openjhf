import React, { PureComponent } from "react";
import { Link } from "react-router-dom";
import { Menu, Tooltip } from "antd";
import CommonSidebar from "../../components/layout/CommonSidebar";
import CommonBreadcrumb from "../../components/general/CommonBreadcrumb";
import BreadcrumbController from "../../controllers/BreadcrumbController";
import QuestionDetail from "../question/detail";
import { filterUrlQuery } from "../../utils/utils";
import RouterController from "../../controllers/RouterController";
import ResourceMenuService from "../../services/resource/ResourceMenuService";
import "./index.less";

class Help extends PureComponent {
  state = {
    breadcrumbs: [],
    menuIdArr: [],
    curMenuId: null,
    sidebarData: []
  };

  componentDidMount() {
    this.getSidebarData();
  }

  componentDidUpdate(prevProps) {
    const search = RouterController.getPathSearch(this.props);
    const prevSearch = RouterController.getPathSearch(prevProps);
    if (search !== prevSearch) {
      this.setActiveMenu();
    }
  }

  getSidebarData = () => {
    ResourceMenuService.index(3).then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      this.setState({ sidebarData: result }, () => {
        this.setActiveMenu();
      });
    });
  };

  setActiveMenu = () => {
    const { sidebarData } = this.state;
    const { id: menuId = sidebarData[0].id } = filterUrlQuery(this.props);
    this.setState({
      menuIdArr: [menuId.toString()],
      curMenuId: menuId
    });
    BreadcrumbController.findBreadcrumb(sidebarData, menuId, [{ text: "帮助中心" }]).then(breadcrumbs => {
      this.setState({ breadcrumbs });
    });
  };

  renderSidebar = (data = []) => {
    const textMaxLength = 6;
    return data.map(item => {
      const { menuName, id } = item;
      return (
        <Menu.Item key={id} className="first-menu">
          <Link to={`/help?id=${id}`}>{menuName.length > textMaxLength ? <Tooltip title={menuName}>{menuName}</Tooltip> : menuName}</Link>
        </Menu.Item>
      );
    });
  };

  render() {
    const { menuIdArr, sidebarData, breadcrumbs, curMenuId } = this.state;
    return (
      <div className="question-list-container">
        <CommonSidebar title="帮助中心">
          <Menu mode="inline" selectedKeys={menuIdArr}>
            {this.renderSidebar(sidebarData)}
          </Menu>
        </CommonSidebar>
        <div className="right-container">
          <CommonBreadcrumb items={breadcrumbs} />
          {curMenuId ? <QuestionDetail id={curMenuId} /> : null}
        </div>
      </div>
    );
  }
}

export default Help;
