import React, { PureComponent } from "react";
import { Menu, Tooltip } from "antd";
import { Link } from "react-router-dom";
import NoticeList from "../../containers/notice/components/NoticeList";
import CommonBreadcrumb from "../../components/general/CommonBreadcrumb";
import CommonSidebar from "../../components/layout/CommonSidebar";
import BreadcrumbController from "../../controllers/BreadcrumbController";
import NoticeTypeService from "../../services/notice/NoticeTypeService";
import RouterController from "../../controllers/RouterController";
import { filterUrlQuery } from "../../utils/utils";
import NoticeDetail from "../../containers/notice/components/NoticeDetail";
import "./index.less";

class Notice extends PureComponent {
  state = {
    breadcrumbs: [],
    menuIdArr: [],
    sidebarData: [
      {
        id: -1,
        msgTypeName: "所有公告"
      }
    ]
  };

  componentDidMount() {
    this.getTypeItems();
  }

  componentDidUpdate(prevProps) {
    const search = RouterController.getPathSearch(this.props);
    const prevSearch = RouterController.getPathSearch(prevProps);
    if (search !== prevSearch) {
      this.setActiveMenu();
    }
  }

  setActiveMenu = () => {
    const { sidebarData } = this.state;
    const { menuid: menuId = sidebarData[0] ? sidebarData[0].id : "", detailid: detailId } = filterUrlQuery(this.props);
    this.setState({
      menuIdArr: [menuId.toString()],
      curMenuId: menuId,
      curDetailId: detailId
    });
    BreadcrumbController.findBreadcrumb(sidebarData, menuId, [{ text: "平台公告" }], { menuName: "msgTypeName" }).then(breadcrumbs => {
      this.setState({ breadcrumbs });
    });
  };

  getTypeItems = () => {
    NoticeTypeService.index().then(res => {
      const { code, result = {} } = res;
      if (code !== "000") return false;
      this.setState(state => ({ sidebarData: state.sidebarData.concat(result.list) || [] }));
      this.setActiveMenu();
    });
  };

  renderSidebar() {
    const { sidebarData } = this.state;
    const textMaxLength = 6;
    return sidebarData.map(item => {
      const { msgTypeName, id } = item;
      return (
        <Menu.Item key={id}>
          <Link to={`/notice?menuid=${id}&detailid=`}>
            {msgTypeName.length > textMaxLength ? <Tooltip title={msgTypeName}>{msgTypeName}</Tooltip> : msgTypeName}
          </Link>
        </Menu.Item>
      );
    });
  }

  render() {
    const { breadcrumbs, menuIdArr, curMenuId, curDetailId } = this.state;
    return (
      <div className="notice-container">
        <CommonSidebar title="平台公告">
          <Menu mode="inline" selectedKeys={menuIdArr}>
            {this.renderSidebar()}
          </Menu>
        </CommonSidebar>
        <div className="notice-right-container">
          <CommonBreadcrumb items={breadcrumbs} />
          {curDetailId ? <NoticeDetail id={curDetailId} /> : curMenuId ? <NoticeList id={curMenuId} /> : null}
        </div>
      </div>
    );
  }
}

export default Notice;
