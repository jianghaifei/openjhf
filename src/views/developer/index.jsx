import React, { useCallback, useEffect, useState } from "react";
import { Menu } from "antd";
import { Link, Redirect, Route, Switch } from "react-router-dom";
import { connect } from "react-redux";
import CommonSidebar from "../../components/layout/CommonSidebar";
import CommonBreadcrumb from "../../components/general/CommonBreadcrumb";
import DeveloperController from "../../controllers/DeveloperController";
import BreadcrumbController from "../../controllers/BreadcrumbController";
import { removeDuplicates } from "../../utils/utils";
import ApplyRecordDetail from "./apply_detail";
import GroupDetail from "./group_detail";
import SidebarController from "../../controllers/SidebarController";
import DeveloperSubPage from "./subpage";
import DeveloperCallback from "./callback";
import "./index.less";

const { SubMenu } = Menu;
const { GROUP_LIST } = DeveloperController.MENU_KEY;
const menuItems = DeveloperController.getMenuItems();

const Developer = props => {
  const { menuKey } = props;
  const [openKeys, updateOpenKeys] = useState([]);
  const [breadcrumbs, updateBreadcrumbs] = useState([]);

  const setOpenKeys = useCallback(keys => updateOpenKeys(keys), []);

  const setActiveMenu = useCallback(() => {
    if (!menuKey) return false;
    SidebarController.asyncFindMenuParent(menuKey, menuItems).then(res => {
      setOpenKeys(removeDuplicates(openKeys.concat(res)));
    });

    BreadcrumbController.findBreadcrumb(menuItems, menuKey, [{ text: "开发者中心" }]).then(data => {
      updateBreadcrumbs(data);
    });
    // eslint-disable-next-line
  }, [menuKey]);

  useEffect(() => {
    setActiveMenu();
  }, [setActiveMenu]);

  const renderSidebar = useCallback((data = []) => {
    return data.map(item => {
      const { id, menuName, childNavigations, parentId } = item;

      if (childNavigations && childNavigations.length) {
        return (
          <SubMenu key={id} title={menuName} className={`${parentId ? "" : "first-menu"}`}>
            {renderSidebar(childNavigations)}
          </SubMenu>
        );
      }

      return (
        <Menu.Item key={id} className={`${"childNavigations" in item ? "first-menu" : ""}`}>
          <Link to={`/developer/${id}`}>{menuName}</Link>
        </Menu.Item>
      );
    });
  }, []);

  return (
    <div className="developer-container">
      <CommonSidebar title="开发者中心">
        <Menu mode="inline" selectedKeys={[menuKey]} openKeys={openKeys} onOpenChange={keys => setOpenKeys(keys)}>
          {renderSidebar(menuItems)}
        </Menu>
      </CommonSidebar>
      <div className="developer-right-container">
        <CommonBreadcrumb items={breadcrumbs} />
        <Switch>
          <Route exact path="/developer/:id" component={DeveloperSubPage} />
          <Route exact path="/developer/group/:id" component={GroupDetail} />
          <Route exact path="/developer/record/:id" component={ApplyRecordDetail} />
          <Route exact path="/developer/callback/:id" component={DeveloperCallback} />
          <Redirect to={`/developer/${GROUP_LIST}`} />
        </Switch>
      </div>
    </div>
  );
};
const mapStateToProps = state => {
  return {
    menuKey: state.developer.get("menuKey")
  };
};
export default React.memo(connect(mapStateToProps)(Developer));
