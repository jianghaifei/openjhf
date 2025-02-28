import { lazy } from "react";
import { GenerateRoutes } from "@restosuite/bo-core";
const { setAuthMeta } = GenerateRoutes;
import * as metas from "@/metas";

// 外卖及配送
const routes = [
  {
    path: "/takeaway-store-binding",
    Component: lazy(() => import("@/pages/Takeaway/StoreBinding")),
    ...setAuthMeta(metas.pageKeys.StoreBinding),
  },
  {
    path: "/takeaway-product-mapping",
    Component: lazy(() => import("@/pages/Takeaway/ProductMapping")),
    ...setAuthMeta(metas.pageKeys.ProductMapping),
  },
  {
    path: "/takeaway-product-mapping-record",
    Component: lazy(() => import("@/pages/Takeaway/ProductMapping/Record")),
    ...setAuthMeta(metas.pageKeys.ProductMappingRecord),
  },
  {
    path: "/takeaway-product-mapping-syncunbind",
    Component: lazy(() => import("@/pages/Takeaway/ProductMapping/SyncUnBind")),
    ...setAuthMeta(metas.pageKeys.ProductMapping),
  },
  {
    path: "/aggregatemanagement",
    Component: lazy(() => import("@/pages/Takeaway/AggregateManagement")),
    ...setAuthMeta(metas.pageKeys.AggregateManagement),
  },
  {
    path: "/aggregatemanagementEdit",
    Component: lazy(() => import("@/pages/Takeaway/AggregateManagement/Edit")),
    ...setAuthMeta(metas.pageKeys.AggregateManagement),
  },
];
export default routes;
