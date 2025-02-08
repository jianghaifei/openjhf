import React, { useCallback, useEffect, useMemo, useState } from "react";
import { Menu, Spin } from "antd";
import CommonSidebar from "../../components/layout/CommonSidebar";
import CommonBreadcrumb from "../../components/general/CommonBreadcrumb";
import BreadcrumbController from "../../controllers/BreadcrumbController";
import QuestionFlatList from "./QuestionFlatList";
import ResourceService from "../../services/resource/ResourceService";
import "./css/QuestionContent.less";

const menuItems = [
  {
    id: "0",
    menuName: "问题指引"
  },
  {
    id: "1",
    menuName: "近期更新"
  }
];

const QuestionContent = props => {
  const { tabId } = props;
  const [menuKey, updateMenuKey] = useState("");
  const [breadcrumbs, updateBreadcrumbs] = useState([]);
  const [loading, updateLoading] = useState(false);
  const [items, updateItems] = useState([]);

  const getItems = useCallback(() => {
    if (!menuKey || !tabId) return false;
    updateLoading(true);
    ResourceService.index(tabId, menuKey)
      .then(res => {
        const { code, result } = res;
        if (code !== "000") return false;
        updateItems(result);
      })
      .finally(() => {
        updateLoading(false);
      });
  }, [menuKey, tabId]);

  useEffect(() => {
    getItems();
  }, [getItems]);

  const sidebarMenuClick = useCallback(async id => {
    updateMenuKey(id);
    const newBreadcrumbs = await BreadcrumbController.findBreadcrumb(menuItems, id, [{ text: "常见问题" }]);
    updateBreadcrumbs(newBreadcrumbs);
  }, []);

  useEffect(() => {
    (async function() {
      await sidebarMenuClick(menuItems[0].id);
    })();
  }, [sidebarMenuClick, tabId]);

  const renderSidebar = useMemo(() => {
    return menuItems.map(item => {
      const { menuName, id } = item;
      return (
        <Menu.Item key={id} className="first-menu" onClick={() => sidebarMenuClick(id)}>
          {menuName}
        </Menu.Item>
      );
    });
  }, [sidebarMenuClick]);

  return (
    <div className="question-content">
      <CommonSidebar title="常见问题FAQ" isFixed={false}>
        <Menu mode="inline" selectedKeys={[menuKey]}>
          {renderSidebar}
        </Menu>
      </CommonSidebar>
      <div className="question-right-container">
        <Spin spinning={loading}>
          <CommonBreadcrumb items={breadcrumbs} />
          <QuestionFlatList items={items} />
        </Spin>
      </div>
    </div>
  );
};

export default React.memo(QuestionContent);
