import React, { PureComponent } from "react";
import { connect } from "react-redux";
import NavigationColumn from "./components/NavigationColumn";
import NavigationController from "../../controllers/NavigationController";
import { changeNavigationVisible } from "../../store/actions/Header";
import "./css/NavigationContent.less";

class NavigationContent extends PureComponent {
  render() {
    const items = NavigationController.getNavigationItems();
    return (
      <div className="navigation-content">
        {items.map((item, index) => {
          return <NavigationColumn {...this.props} index={index} {...item} key={index} />;
        })}
      </div>
    );
  }
}
const mapDispatchToProps = {
  changeNavigationVisible
};
export default connect(
  null,
  mapDispatchToProps
)(NavigationContent);
