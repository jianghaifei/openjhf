import { GenerateRoutes } from "@restosuite/bo-core";

import routes from "./routes";
import * as metas from "./metas";

import 'index.less';

const { GenerateRoutes: generate } = GenerateRoutes;

export function getRoutes() {
  return generate(routes);
}

export function getPageMetas() {
  return metas.pageMetas;
}