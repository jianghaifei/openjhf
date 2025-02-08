import React, { PureComponent } from "react";
import { Table, Tooltip, Button, message } from "antd";
import lodash from "lodash";
import DeveloperDebugService from "../../services/developer/DeveloperDebugService";
import DeveloperController from "../../controllers/DeveloperController";
import FilterController from "../../controllers/FilterController";
import DebugDialog from "./DebugDialog";
import SearchBar from "../../components/general/SearchBar";
import DeveloperTitle from "./components/DeveloperTitle";
import "./css/Debug.less";

class Debug extends PureComponent {
  // todo 请求查询使用
  columns = [
    {
      title: "操作",
      render: (text, item) => {
        return (
          <Button type="primary" onClick={() => this.showDialog(item)}>
            详情
          </Button>
        );
      }
    },
    {
      title: "请求时间",
      dataIndex: "requestTime",
      render: text => text || "---"
    },
    {
      title: "响应时间",
      dataIndex: "responseTime",
      render: text => text || "---"
    },
    {
      title: "集团ID",
      dataIndex: "groupID",
      width: 100,
      render: text => text || "---"
    },
    {
      title: "店铺ID",
      dataIndex: "shopID",
      width: 120,
      render: text => text || "---"
    },
    {
      title: "URL",
      dataIndex: "url",
      ellipsis: true,
      render: text => {
        return text ? (
          <Tooltip placement="topLeft" title={text}>
            {text}
          </Tooltip>
        ) : (
          "---"
        );
      }
    },
    {
      title: "输入",
      dataIndex: "requestBody",
      ellipsis: true,
      render: text => {
        return text ? (
          <Tooltip placement="topLeft" title={text}>
            {text}
          </Tooltip>
        ) : (
          "---"
        );
      }
    },
    {
      title: "输出",
      dataIndex: "responseBody",
      ellipsis: true,
      render: text => {
        return text ? (
          <Tooltip placement="topLeft" title={text}>
            {text}
          </Tooltip>
        ) : (
          "---"
        );
      }
    }
  ];

  // todo 另外两个使用
  columns1 = [
    {
      title: "操作",
      render: (text, item) => {
        return (
          <Button type="primary" onClick={() => this.showDialog(item)}>
            详情
          </Button>
        );
      }
    },
    {
      title: "时间",
      dataIndex: "time",
      render: text => text || "---"
    },
    {
      title: "集团ID",
      dataIndex: "groupID",
      width: 100,
      render: text => text || "---"
    },
    {
      title: "店铺ID",
      dataIndex: "shopID",
      width: 120,
      render: text => text || "---"
    },
    {
      title: "URL",
      dataIndex: "url",
      ellipsis: true,
      render: text => {
        return text ? (
          <Tooltip placement="topLeft" title={text}>
            {text}
          </Tooltip>
        ) : (
          "---"
        );
      }
    },
    {
      title: "状态码",
      dataIndex: "statusCode",
      width: 80,
      render: text => text || "---"
    },
    {
      title: "信息",
      dataIndex: "remark",
      ellipsis: true,
      render: text => {
        return text ? (
          <Tooltip placement="topLeft" title={text}>
            {text}
          </Tooltip>
        ) : (
          "---"
        );
      }
    }
  ];

  state = {
    // todo 默认type是请求查询
    type: FilterController.debugType(DeveloperController.MENU_KEY.DEBUG.REQUEST),
    items: [],
    loading: false,
    debugDialogVisible: false,
    currentItem: null,
    searchInstance: null,
    searchOptions: [
      {
        type: "input",
        label: "traceID",
        key: "keywords",
        placeholder: "请输入traceID",
        value: null,
        props: {
          style: {
            width: "340px"
          }
        }
      }
    ],
    curColumns: this.columns,
    title: "请求查询"
  };

  componentDidMount() {
    this.initStatus();
  }

  componentDidUpdate(prevProps) {
    const { m } = this.props;
    const { m: prevM } = prevProps;
    if (m !== prevM) {
      this.initStatus();
    }
  }

  getItems(keywords) {
    const { type, loading } = this.state;
    if (loading) return false;
    this.setState({ loading: true });
    const params = { type, key: keywords };
    DeveloperDebugService.index(params)
      .then(res => {
        const { code, result } = res;
        if (code !== "000") return false;
        if (!result.length) message.warning("没有查到相关数据");

        const items = result.map((item, index) => {
          return { ...item, index };
        });
        this.setState({
          items
        });
      })
      .finally(() => {
        this.setState({ loading: false });
      });
  }

  handleOnSubmit = values => {
    const { keywords } = values;
    this.getItems(keywords);
  };

  handleDialogOnClick = () => {
    this.setState({
      debugDialogVisible: false
    });
  };

  showDialog = item => {
    this.setState({
      debugDialogVisible: true,
      currentItem: item
    });
  };

  getSearchInstance = instance => {
    this.setState({
      searchInstance: instance
    });
  };

  // todo 每次切换页面清空状态
  initStatus() {
    const { searchInstance } = this.state;
    const { m } = this.props;
    const { REQUEST, BILL } = DeveloperController.MENU_KEY.DEBUG;
    if (searchInstance) searchInstance.resetFields();
    this.setState(state => {
      const newSearchOptions = lodash.cloneDeep(state.searchOptions);
      newSearchOptions[0].label = m === REQUEST ? "traceID" : m === BILL ? "账单号" : "订单号";
      newSearchOptions[0].placeholder = `请输入${newSearchOptions[0].label}`;
      return {
        type: FilterController.debugType(m),
        items: [],
        loading: false,
        searchOptions: newSearchOptions,
        curColumns: m === REQUEST ? this.columns : this.columns1,
        title: m === REQUEST ? "请求查询" : m === BILL ? "账单推送" : "订单状态推送"
      };
    });
  }

  render() {
    const { m } = this.props;
    const { items = [], debugDialogVisible, currentItem, searchOptions, curColumns, title } = this.state;
    return (
      <div className="debug">
        <DeveloperTitle title={title} />
        <SearchBar options={searchOptions} getInstance={this.getSearchInstance} onSubmit={this.handleOnSubmit} />
        <Table
          style={{ marginTop: 10 }}
          rowKey="index"
          columns={curColumns}
          dataSource={items}
          pagination={false}
          scroll={items.length > 10 ? { y: "100%" } : {}}
        />
        <DebugDialog visible={debugDialogVisible} item={currentItem} menuid={m} handleClick={this.handleDialogOnClick} />
      </div>
    );
  }
}

export default Debug;
