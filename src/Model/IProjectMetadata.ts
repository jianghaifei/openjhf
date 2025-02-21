import { ICommonConfig } from "../Model/ICommonModel";
import { IPageMetadata } from "@/Model/IPageMetadata";
import { IComponent } from "@/Model/IComponent";

export interface IComponentConfig {
  componentName: string,
  package?: string,
  version?: string,
  destructuring: boolean
}

export interface IPageConfig {
  id: string;
  type: string; //page | container
  path: string;
  title?:string;
}

export interface IProjectMetadata {
  id: string;
  type: 'Project'; //page | container
  title?: string;
  version: string;
  description?: string
  template?: string
  config?: ICommonConfig;
  componentsMap?: IComponentConfig[]
  style?: ICommonConfig;
  pages?: IPageConfig[]
  componentsTree?: IComponent[];
}