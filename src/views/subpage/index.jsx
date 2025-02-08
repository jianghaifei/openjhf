import React, { lazy } from "react";
import { Route, Switch } from "react-router-dom";
import OpenApiFooter from "../../containers/footer";
import SubpageWorkflow from "../../containers/subpage/components/SubpageWorkflow";

const Subpage = () => {
  return (
    <div className="subpage">
      <Switch>
        <Route exact path="/subpage/takeout" component={lazy(() => import("./takeout"))} />
        <Route exact path="/subpage/data" component={lazy(() => import("./data"))} />
        <Route exact path="/subpage/distribution" component={lazy(() => import("./distribution"))} />
        <Route exact path="/subpage/marketing" component={lazy(() => import("./marketing"))} />
        <Route exact path="/subpage/payment" component={lazy(() => import("./payment"))} />
        <Route exact path="/subpage/shop" component={lazy(() => import("./shop"))} />
        <Route exact path="/subpage/retail" component={lazy(() => import("./retail"))} />
      </Switch>
      <SubpageWorkflow />
      <OpenApiFooter />
    </div>
  );
};
export default React.memo(Subpage);
