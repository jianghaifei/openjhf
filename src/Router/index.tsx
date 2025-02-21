import { Suspense, lazy } from "react";
import ExtraRouter from "./helper";
import { RouteObject } from "react-router-dom";
import Framework from "../Basic/Framework";
import Loading from "../Basic/Loading";

type LazyReturn = ReturnType<typeof lazy>;
const routerLazyLoadingFn = (Element: LazyReturn) => (
  <Suspense fallback={<Loading></Loading>}>
    <Element />
  </Suspense>
);

const routesList: RouteObject[] = [
  {
    path: "/",
    element: routerLazyLoadingFn(lazy(() => import("../App"))),
    children: [
      {
        index: true,
        // path: "/scheme",
        element: routerLazyLoadingFn(lazy(() => import("@/Pages/Scheme"))),
      },
      {
        path: "/designer",
        element: routerLazyLoadingFn(lazy(() => import("@/Pages/designer"))),
        children: [
          {
            index: true,
            // path: "/app/theme",
            element: routerLazyLoadingFn(
              lazy(() => import("@/Pages/designer/theme"))
            ),
          },
          {
            index: true,
            path: "/designer/order/layout",
            element: routerLazyLoadingFn(
              lazy(() => import("@/Pages/designer/order/layout"))
            ),
          },
          {
            path: "/designer/designer",
            element: routerLazyLoadingFn(
              lazy(() => import("@/Pages/designer/designer/index"))
            ),
          },
        ],
      },
    ],
  },
];

const routes = () => {
  return (
    <Framework>
      <ExtraRouter extraRoutes={routesList}></ExtraRouter>
    </Framework>
  );
};
export default routes;
