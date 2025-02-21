declare module "*.svg" {
  import * as React from "react";

  export const ReactComponent: React.FunctionComponent<
    React.ComponentProps<"svg"> & { title?: string }
  >;
}

declare module '*.yaml' {
  const value: Record<string, any>;
  export default value;
}
declare module '*.yml' {
  const value: Record<string, any>;
  export default value;
}
declare module '@cyrilis/flame';
declare module '@cyrilis/code-generator/standalone-loader'
declare module 'tiny-invariant'
declare module 'shallowequal'