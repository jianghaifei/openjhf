
import { lazy } from "react";
import { GenerateRoutes } from "@restosuite/bo-core";
const { setAuthMeta } = GenerateRoutes;

import * as metas from "@/metas";

const routes = [
  {
    path: "hello",
    Component: lazy(() => import("@/pages/example/hello"))
  },
  {
    path: "delivery-order",
    ...setAuthMeta(metas.pageKeys.ExampleDeliveryOrder),
    Component: lazy(() => import("@/pages/example/delivery-order/List"))
  },
];

export default routes;
