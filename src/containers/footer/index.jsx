import React, { PureComponent } from "react";
import { Link, withRouter } from "react-router-dom";
import { connect } from "react-redux";
// import { LazyLoadImage } from "react-lazy-load-image-component";
import FooterColumn from "./components/FooterColumn";
// import logo from "../../assets/images/logo.png";
import { ReactComponent as Logobox } from "./Logo.svg";
import NavigationController from "../../controllers/NavigationController";
import { changeLoginDialogVisible, changeRealNameDialogVisible } from "../../store/actions/Common";
import "./index.less";

class OpenApiFooter extends PureComponent {
  state = {
    items: [
      {
        title: "业务类型",
        items: [
          {
            title: "快餐",
            root: "resource",
            isResourceId: true
          },
          {
            title: "正餐",
            root: "resource"
          },
          {
            title: "茶饮",
            root: "resource"
          },
          {
            title: "火锅",
            root: "resource"
          },
          {
            title: "称重",
            root: "resource"
          },
          {
            title: "烘焙",
            root: "resource"
          },
          {
            title: "酒吧",
            root: "resource"
          },
          {
            title: "咖啡",
            root: "resource"
          },
          {
            title: "专业服务",
            root: "resource"
          }
        ]
      },
      {
        title: "资源",
        items: [
          {
            title: "报价",
            root: "subpage",
            linkKey: "takeout"
          },
          {
            title: "为什么选择",
            root: "subpage",
            linkKey: "shop"
          },
          {
            title: "支持",
            root: "subpage",
            linkKey: "retail"
          },
          {
            title: "开发者平台",
            root: "subpage",
            linkKey: "distribution"
          },
          {
            title: "社区",
            root: "subpage",
            linkKey: "distribution"
          }
        ]
      },
      {
        title: "联系",
        items: [
          {
            title: "客户支持:(086)400-6000"
          },
          {
            title: "销售:(086)470-1673"
          },
          {
            title: "分公司"
          },
          {
            title: "合作伙伴"
          }
        ]
      }
    ]
  };

  pushToPage = item => {
    const { history } = this.props;
    const { linkKey, isResourceId, root, isVerifyRealName } = item;
    if (!root) return false;
    const targetUrl = NavigationController.getTargetUrl({ root, linkKey, isResourceId });
    if (isVerifyRealName) {
      NavigationController.verifyRealName().then(status => {
        switch (status) {
          case NavigationController.verifyRealNameStatus().NO_LOGIN:
            this.props.changeLoginDialogVisible(true);
            break;
          case NavigationController.verifyRealNameStatus().NO_REAL_NAME:
            this.props.changeRealNameDialogVisible(true);
            break;
          default:
            NavigationController.filterRouter(history, targetUrl);
        }
      });
    } else {
      NavigationController.filterRouter(history, targetUrl);
    }
  };

  render() {
    const { items } = this.state;
    return (
      <div className="openapi-footer">
        {/* <div className="footer-container">
          <div className="footer-left">
            <Link to="/">
              <Logobox />
            </Link>
            <h2>
              <span>申请体验</span>
            </h2>
          </div>
          {items.map((item, index) => {
            return <FooterColumn {...item} pushToPage={this.pushToPage} key={index} />;
          })}
        </div> */}
        <div className="footer-record">
          <dl>
            <dd>
              <a href="https://www.restosuite.cn/" style={{ marginRight: "40px" }}>
                <Logobox />
              </a>
              Copyright{" "}
              <a href="/operation" style={{ color: "rgba(255, 255, 255, 0.6)" }}>
                ©
              </a>{" "}
              2024 上海睿食拓科技有限公司 
            </dd>
            <dt>
              <a href="https://www.restosuite.cn/protocol">用户服务协议</a>
              <a href="https://www.restosuite.cn/privacy">隐私政策</a>
              <a
                href="https://static.restosuite.cn/privacy/insight_privacy.html
"
              >
                RestoSuite Insight 隱私政策
              </a>
            </dt>
          </dl>
        </div>
      </div>
    );
  }
}

const mapStateToProps = ({ common, user }) => {
  const { isLogin } = common;
  const { isRealName } = user;
  return {
    isLogin,
    isRealName
  };
};
const mapDispatchToProps = {
  changeLoginDialogVisible,
  changeRealNameDialogVisible
};
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(withRouter(OpenApiFooter));
