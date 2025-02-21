/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-empty-function */
import { CraftDOMEvent, DerivedEventHandlers, EventHandlers } from '@/Components/Designer/Layout/utils';

import { EditorStore } from '../editor/store';
import { NodeId, NodeTree } from '../interfaces/nodes';

export interface CreateHandlerOptions {
  onCreate: (nodeTree: NodeTree, e: CraftDOMEvent<DragEvent>) => void;
}

export class CoreEventHandlers<O = any> extends EventHandlers<
  { store: EditorStore } & O
> {
  handlers() {
    return {
      connect: (el: HTMLElement, id: NodeId) => {},
      select: (el: HTMLElement, id: NodeId) => {},
      hover: (el: HTMLElement, id: NodeId) => {},
      drag: (el: HTMLElement, id: NodeId) => {},
      drop: (el: HTMLElement, id: NodeId) => {},
      create: (
        el: HTMLElement,
        UserElement: React.ReactElement | (() => NodeTree | React.ReactElement),
        options?: Partial<CreateHandlerOptions>
      ) => {},
    };
  }
}

export abstract class DerivedCoreEventHandlers<
  O extends Record<string, any> = object
> extends DerivedEventHandlers<CoreEventHandlers, O> {}
