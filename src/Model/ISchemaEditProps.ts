/* eslint-disable @typescript-eslint/no-explicit-any */

import BasicComponentModel from "@/ViewModel/BasicComponentModel";
import { IComponentPropsSchema } from "./IScema";

export interface ISchemaEditProps<T = any> {
  value: T; //这里应该是泛型，包括onchange
  editable?: boolean;
  schema: IComponentPropsSchema;
  onChange?: (value: T) => void;
  currentModel?: BasicComponentModel;
}
