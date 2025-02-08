import React, { PureComponent } from "react";
import { Menu, Spin, Tooltip, message } from "antd";
import { Link, withRouter } from "react-router-dom";
import CommonBreadcrumb from "../../components/general/CommonBreadcrumb";
import CommonSidebar from "../../components/layout/CommonSidebar";
import BreadcrumbController from "../../controllers/BreadcrumbController";
import SidebarController from "../../controllers/SidebarController";
import ResourceDetail from "../../containers/document/component/DocumentDetail";
import { filterUrlParams, removeDuplicates, timeFormat } from "../../utils/utils";
import NavigationController from "../../controllers/NavigationController";
import RouterController from "../../controllers/RouterController";
import CommonContent from "../../components/layout/CommonContent";
import ResourceMenuService from "../../services/resource/ResourceMenuService";
import "./index.less";
import ResourceService from "../../services/resource/ResourceService";
import ResourceController from "../../controllers/ResourceController";
import { queryTree, apiQuery } from "../../services/operation/index";
import dayjs from "dayjs";
import _ from "lodash";
const { SubMenu } = Menu;

class Resource extends PureComponent {
  state = {
    menuIdArr: [],
    parentIdArr: [],
    breadcrumbs: [{ text: "业务文档" }],
    sidebarData: [],
    detailInfo: null,
    listLoading: false, // todo list loading时需要覆盖全屏
    detailLoading: false // todo 详情loading时只覆盖内容区域 方便随时切换文档
  };

  componentDidMount() {
    this.querySidebarData();
  }

  componentDidUpdate(prevProps) {
    const pathname = RouterController.getPathname(this.props);
    const prevPathname = RouterController.getPathname(prevProps);
    if (pathname !== prevPathname) {
      this.setActiveMenu();
    }
  }

  componentWillUnmount() {
    this.setState = () => {};
  }

  setActiveMenu = () => {
    let { id: menuId } = filterUrlParams(this.props);
    const { sidebarData, parentIdArr } = this.state;
    // todo 带链接进入
    if (menuId) {
      SidebarController.asyncFindMenuParent(menuId, sidebarData).then(res => {
        this.sidebarSubMenuClick(removeDuplicates(parentIdArr.concat(res)));
      });
    }
    // todo 默认不带链接进入 选择第一个
    if (!menuId) {
      const { selectedKey, openKeys } = this.setDefaultMenu();
      menuId = selectedKey;
      this.sidebarSubMenuClick(openKeys);
    }
    this.setState({
      menuIdArr: [menuId]
    });
    this.getItem(menuId);
    BreadcrumbController.findBreadcrumb(sidebarData, menuId).then(breadcrumbs => {
      this.setState({ breadcrumbs: [{ text: "业务文档" }].concat(breadcrumbs) });
    });
  };

  renderSidebar = (data = []) => {
    const textMaxLength = 6;
    return data.map(item => {
      const { childNavigations, menuName, id, parentId } = item;
      if (childNavigations && childNavigations.length) {
        return (
          <SubMenu key={`${id}`} eventKey={`${id}`} title={menuName} className={`${parentId ? "" : "first-menu"}`}>
            {menuName.length > textMaxLength ? (
              <Tooltip title={menuName}>{this.renderSidebar(childNavigations)}</Tooltip>
            ) : (
              this.renderSidebar(childNavigations)
            )}
          </SubMenu>
        );
      }
      return (
        <Menu.Item key={`${id}`}>
          <Link to={`/resource/${id}`}>{menuName.length > textMaxLength ? <Tooltip title={menuName}>{menuName}</Tooltip> : menuName}</Link>
        </Menu.Item>
      );
    });
  };

  setDefaultMenu = () => {
    const { sidebarData } = this.state;
    const { selectedKey, openKeys } = SidebarController.findFirstMenuId(sidebarData);
    return { selectedKey, openKeys };
  };

  querySidebarData = () => {
    this.setState({
      listLoading: true
    });
    queryTree({})
      .then(res => {
        const formateData = treeDtae => {
          const _treeDtae = _.cloneDeep(treeDtae);
          const _data = {
            subNodes: _treeDtae,
            code: "1",
            name: "1"
          };
          const deepData = data => {
            if (data.subNodes && data.subNodes.length > 0) {
              data.childNavigations = data.subNodes.map(el => {
                deepData(el);
                return el;
              });
            }
            const list = [];
            if (data.apiList && data.apiList.length > 0) {
              data.apiList.map(item => {
                const li = {
                  id: item.apiUid,
                  menuName: item.apiName
                };
                list.push(li);
              });
            }
            if (list.length > 0) {
              if (!data.childNavigations) {
                data.childNavigations = [];
              }
              data.childNavigations = [...data.childNavigations, ...list];
            }
            data.id = data.code;
            data.parentId = data.code;
            data.menuName = data.name;
            return data;
          };
          const res = deepData(_data);
          console.log("ddddd", res);
          return res.childNavigations;
        };
        // 自定义渲染每个树节点
        this.setState(
          {
            sidebarData: formateData(res.data.topNodes)
          },
          () => {
            this.setActiveMenu();
          }
        );
      })
      .finally(() => {
        this.setState({
          listLoading: false
        });
      });
    // ResourceMenuService.index(4)
    //   .then(res => {
    //     const { code, result } = res;
    //     if (code !== "000") return false;
    //     // this.setState(
    //     //   {
    //     //     sidebarData: result
    //     //   },
    //     //   () => {
    //     //     this.setActiveMenu();
    //     //   }
    //     // );
    //   })
    //   .finally(() => {
    //     this.setState({
    //       listLoading: false
    //     });
    //   });
  };

  sidebarSubMenuClick = openKeys => {
    this.setState({
      parentIdArr: openKeys
    });
  };

  getItem = menuId => {
    const { history } = this.props;
    this.setState({
      detailLoading: true
    });
    apiQuery({
      apiUid: menuId
    })
      .then(res => {
        if (res.code != "000") {
          return message.warning(res.msg);
        }
        const data = res.data;
        this.setState({
          detailInfo: {
            contentTitle: data.apiName,
            content: data.apiDocHtml === "<p></p>" ? "" : data.apiDocHtml,
            type: 3,
            modifyTime: data.modifyTime
          }
        });
      })
      .finally(() => {
        this.setState({
          detailLoading: false
        });
      });
    // ResourceService.show(menuId, 4)
    //   .then(res => {
    //     const { code, result = {} } = res;
    //     const { content, type, contentTitle, modifyTime } = result;
    //     if (code === "111213") {
    //       NavigationController.filterRouter(history, "/user");
    //       return false;
    //     }
    //     if (code === "010103") {
    //       this.setState({ detailInfo: null });
    //       return false;
    //     }
    //     if (code !== "000") return false;
    //     this.setState({
    //       detailInfo: {
    //         contentTitle,
    //         content: content === "<p></p>" ? "" : content,
    //         type: Number(type),
    //         modifyTime: timeFormat(modifyTime)
    //       }
    //     });
    //   })
    //   .finally(() => {
    //     this.setState({
    //       detailLoading: false
    //     });
    //   });
  };

  renderUpdateTime = () => {
    const { detailInfo } = this.state;
    const { modifyTime } = detailInfo || {};

    return ResourceController.renderUpdateTime(dayjs(modifyTime).format("YYYY.MM.DD HH:mm:ss"));
  };

  render() {
    const { menuIdArr, parentIdArr, breadcrumbs, sidebarData, listLoading, detailLoading, detailInfo } = this.state;
    return (
      <div className="document-container">
        <Spin tip="加载中" wrapperClassName="spin-parent" spinning={listLoading}>
          <CommonSidebar title="业务文档" showWider>
            <Menu
              mode="inline"
              selectedKeys={menuIdArr}
              openKeys={parentIdArr}
              onOpenChange={openKeys => this.sidebarSubMenuClick(openKeys)}
            >
              {this.renderSidebar(sidebarData)}
            </Menu>
          </CommonSidebar>
          <div className="resource-right-container">
            <CommonBreadcrumb items={breadcrumbs} rightSlot={this.renderUpdateTime()} />
            <CommonContent extraHeight={20}>
              <Spin tip="加载中" spinning={detailLoading}>
                <ResourceDetail {...detailInfo} />
              </Spin>
            </CommonContent>
          </div>
        </Spin>
      </div>
    );
  }
}

export default withRouter(Resource);
