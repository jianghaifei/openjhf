import { ICommonConfig } from "./ICommonModel";
import { IComponent, IComponentLayout } from "./IComponent";

export interface IPageMetadata {
  id: string;
  type: string; //page | container
  title?: string;
  props: ICommonConfig;
  style: ICommonConfig;
  componentsTree: IComponent[];
  layout?: IComponentLayout | null; //仅在type为container的时候生效
}
