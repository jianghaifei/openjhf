import { RouteObject } from "react-router-dom";
export type ILoaderData = {
  pageUtils: any;
  meta?: IMeta;
};
export type IMeta = {
  page_id?: string;
  pageName?: string;
  layoutType?: string;
  reportId?: string;
  subRoutes?: string[];
};
export type IRoute = {
  path: string;
  meta?: IMeta;
  children?: IRoute[];
  loader?: RouteObject["loader"];
  Component: React.ComponentType;
};
