import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Input, Menu, message } from "antd";
import { Link } from "react-router-dom";
import { Markup } from "interweave";
import { nanoid } from "nanoid";
import SearchService from "../../services/search/SearchService";
import "./index.less";
import CommonBackTop from "../../components/general/CommonBackTop";
import CommonSidebar from "../../components/layout/CommonSidebar";
import NoData from "../../components/general/NoData";
import { changeRealNameDialogVisible } from "../../store/actions/Common";

const { SubMenu } = Menu;
const { Search } = Input;
const pageSize = 30;

class SearchPage extends PureComponent {
  constructor(props) {
    super(props);
    const keyWord = props.location.state ? props.location.state : "";
    this.state = {
      isLoading: false,
      params: {
        parentNavId: undefined,
        keyWord,
        from: 0,
        pageSize
      },
      totalHits: 0,
      openKeys: [],
      selectedKeys: [],
      navList: [],
      hitSourceList: []
    };
  }

  componentDidMount() {
    const { params } = this.state;
    if (params.keyWord) {
      this.queryCountNav(params.keyWord);
    }
  }

  componentWillUnmount() {
    this.setState = () => {};
  }

  // 查询左侧的菜单
  queryCountNav = value => {
    if (value.trim()) {
      const { params } = this.state;
      const openKeys = [];
      const selectedKeys = [];
      SearchService.queryCountByKeyWord({ keyWord: value }).then(res => {
        if (res.code !== "000") return false;
        const result = res.result ? res.result : [];
        result.map((menu, index) => {
          if (menu.childNavList && menu.childNavList.length > 0) {
            openKeys.push(index.toString());
          } else if (!menu.navName) {
            selectedKeys.push(`sub${index}`);
          }
          return menu;
        });
        this.setState({
          navList: result,
          selectedKeys,
          openKeys
        });
      });
      const newParams = { ...params };
      // 查询左侧菜单说明是重新搜索，from 重置0
      newParams.from = 0;
      this.setState({
        params: newParams
      });
      this.queryContent(newParams, true);
    } else {
      this.setState({
        totalHits: 0,
        openKeys: [],
        selectedKeys: [],
        navList: [],
        hitSourceList: []
      });
    }
  };

  // 查询记录内容
  queryContent = (params, reset) => {
    const { hitSourceList, params: stateParams, isLoading } = this.state;
    if (isLoading) return false;
    let oldList = [...hitSourceList];
    if (reset) {
      oldList = [];
    }
    this.setState({ isLoading: true });
    SearchService.queryContentByKeyWordsHL(params)
      .then(res => {
        const { code, result } = res;
        const resList = result.hitSource ? result.hitSource : [];
        const newParams = { ...stateParams };
        newParams.from += resList.length;
        if (code !== "000") return false;
        this.setState({
          totalHits: result.totalHits || 0,
          hitSourceList: [...oldList, ...resList],
          params: newParams
        });
      })
      .finally(() => {
        this.setState({ isLoading: false });
      });
  };

  // 搜索框文字修改
  handleValueChange = ({ target: { value } }) => {
    const { params } = this.state;
    const newParams = { ...params };
    newParams.keyWord = value;
    this.setState({
      params: newParams
    });
  };

  // 加载更多
  getMoreData = () => {
    const { params, totalHits } = this.state;
    const newParams = { ...params };
    if (newParams.from < totalHits) {
      this.queryContent(newParams);
    }
  };

  recursion = (dataSource = []) => {
    return dataSource.map((item, index) => {
      const { childNavList, navName, navId, navTypeName, hitNum, parentId } = item;
      if (childNavList && childNavList.length > 0) {
        return (
          <SubMenu key={index} title={`${navTypeName}(${hitNum})`} className={`${parentId ? "" : "first-menu"}`}>
            {this.recursion(childNavList)}
          </SubMenu>
        );
      }
      if (navName) {
        return <Menu.Item key={navId}>{navName}</Menu.Item>;
      }
      return <Menu.Item key={`sub${index}`}>{`${navTypeName}（${hitNum}）`}</Menu.Item>;
    });
  };

  // 权限限制加载列表
  checkHitSourceList = hitSourceList => {
    const { isLogin, isRealName, checkStatus } = this.props;
    return hitSourceList.map(value => {
      const item = { ...value };
      const apiFlag = item.isapiDoc === 1;
      item.content += "&nbsp;...";
      if ((apiFlag && isLogin && isRealName) || !apiFlag) {
        const linkUrl = item.navType === 4 ? `/resource/${item.naviId}` : item.navType === 3 ? `/question?detail=${item.naviId}` : "";
        return (
          <li className="listItem" key={`${nanoid()}_${item.contId}`}>
            {linkUrl ? (
              <Link to={linkUrl} target="_blank">
                <Markup className="common-mark-up title" content={item.title} />
              </Link>
            ) : (
              <Markup className="common-mark-up title" content={item.title} />
            )}
            <div className="description">
              <Markup className="common-mark-up" content={item.content} />
            </div>
          </li>
        );
      }
      return (
        <li className="listItem" key={`${nanoid()}_${item.contId}`}>
          <p
            className="title"
            onClick={() => {
              if (!isLogin) {
                message.error("请登录！");
                return;
              }
              if (!isRealName) {
                switch (checkStatus) {
                  case 1:
                    message.warning("资料审核中，暂时无法查看！");
                    break;
                  default:
                    this.props.changeRealNameDialogVisible(true);
                }
              }
            }}
          >
            <Markup className="common-mark-up" content={item.title} />
          </p>
        </li>
      );
    });
  };

  sidebarSubMenuClick(openKeys) {
    this.setState({
      openKeys
    });
  }

  sidebarMenuClick(e) {
    this.setState({
      selectedKeys: [e.key]
    });
    const key = parseInt(e.key, 10);
    const newParams = { ...this.state.params };
    newParams.from = 0;
    if (key) {
      newParams.parentNavId = key;
    } else {
      newParams.parentNavId = undefined;
    }
    this.queryContent(newParams, true);
  }

  render() {
    const { params, totalHits, openKeys, selectedKeys, navList, hitSourceList } = this.state;
    return (
      <div className="search-page">
        <div className="contentWrapper">
          <Search
            value={params.keyWord}
            enterButton="搜索"
            size="large"
            allowClear
            onSearch={value => this.queryCountNav(value)}
            onChange={this.handleValueChange}
            style={{ width: 475, margin: "50px auto" }}
          />
          <div className="contentBody">
            <CommonSidebar title="搜索" top={210}>
              <Menu
                mode="inline"
                selectedKeys={selectedKeys}
                openKeys={openKeys}
                style={{ height: "100%" }}
                onClick={e => {
                  this.sidebarMenuClick(e);
                }}
                onOpenChange={e => {
                  this.sidebarSubMenuClick(e);
                }}
              >
                {navList.length !== 0 ? null : <Menu.Item key="0">所有记录(0)</Menu.Item>}
                {this.recursion(navList)}
              </Menu>
            </CommonSidebar>
            <div className="search-content">
              {hitSourceList && hitSourceList.length ? <ul className="selectList">{this.checkHitSourceList(hitSourceList)}</ul> : null}

              {totalHits > params.from ? (
                <p className="getMoreItem" onClick={this.getMoreData}>
                  查看更多
                </p>
              ) : null}
              {totalHits === 0 ? <NoData /> : null}
            </div>
            <CommonBackTop />
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = ({ common, user }) => {
  const { isLogin } = common;
  const { isRealName, checkStatus } = user;
  return {
    isLogin,
    isRealName,
    checkStatus
  };
};
const mapDispatchToProps = {
  changeRealNameDialogVisible
};
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(SearchPage);
