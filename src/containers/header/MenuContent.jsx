import React, { PureComponent } from "react";
import { withRouter } from "react-router-dom";
import { connect } from "react-redux";
import { Tabs } from "antd";
import { changeNavigationVisible } from "../../store/actions/Header";
import { changeLoginDialogVisible, changeRealNameDialogVisible } from "../../store/actions/Common";
// import MenuItem from "./components/MenuItem";
import NavigationContent from "./NavigationContent";
import NavigationController from "../../controllers/NavigationController";
import "./css/MenuContent.less";

class MenuContent extends PureComponent {
  state = {
    items: NavigationController.getTopMenuItems(),
    isHover: false,
    activeKey: null
  };

  componentDidMount() {
    const { history } = this.props;
    history.listen(location => {
      if (location.pathname === "/") {
        this.setState({
          isHover: false,
          activeKey: null
        });
      }
    });
  }

  listenItemClick = item => {
    const { isVerifyRealName, to } = item;
    if (!to) return false;
    this.pushToPage(to);
  };

  pushToPage(to) {
    const { history } = this.props;
    NavigationController.filterRouter(history, to);
  }

  render() {
    const { items, isHover, activeKey } = this.state;
    // const { currentMenuIndex, navigationContentVisible } = this.props;
    return (
      <div
        className="menu-tabs"
        onMouseLeave={() => {
          this.setState({
            isHover: false
          });
        }}
      >
        <Tabs
          defaultActiveKey={activeKey}
          activeKey={activeKey}
          onChange={e => {
            if (e === "1") {
              return;
            }
            const el = items.find(item => item.id === e);
            this.setState({
              activeKey: e
            });
            this.listenItemClick(el);
          }}
        >
          {items.map(item => (
            <Tabs.TabPane
              tab={
                <span
                  onMouseEnter={() => {
                    if (item.id === "1") {
                      this.setState({
                        isHover: true
                      });
                    } else {
                      this.setState({
                        isHover: false
                      });
                    }
                  }}
                >
                  {item.text}
                </span>
              }
              key={item.id}
              to={item.to}
              data-id={item.id}
            />
          ))}
        </Tabs>
        <div
          onMouseLeave={() => {
            this.setState({
              isHover: false
            });
          }}
          onClick={() => {
            this.setState({
              isHover: false,
              activeKey: "1"
            });
          }}
        >
          {isHover ? <NavigationContent /> : null}
        </div>
      </div>
    );
  }
}

const mapStateToProps = ({ header }) => {
  const { currentMenuIndex, navigationContentVisible } = header;
  return { currentMenuIndex, navigationContentVisible };
};
const mapDispatchToProps = {
  changeNavigationVisible,
  changeLoginDialogVisible,
  changeRealNameDialogVisible
};
export default withRouter(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(MenuContent)
);
