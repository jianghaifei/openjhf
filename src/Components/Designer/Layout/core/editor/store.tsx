import {
  useMethods,
  SubscriberAndCallbacksFor,
  PatchListener
} from '@/Components/Designer/Layout/utils'

import { ActionMethods } from './actions'
import { QueryMethods } from './query'

import { DefaultEventHandlers } from '../events'
import { EditorState, Options, NodeEventTypes, NodeId } from '../interfaces'

// eslint-disable-next-line react-refresh/only-export-components
export const editorInitialState: EditorState = {
  nodes: {},
  events: {
    dragged: new Set<NodeId>(),
    selected: new Set<NodeId>(),
    hovered: new Set<NodeId>()
  },
  indicator: null,
  options: {
    onNodesChange: () => null,
    onRender: ({ render }) => render,
    onBeforeMoveEnd: () => null,
    resolver: {},
    enabled: true,
    scale: 1,
    skew: false,
    gap: true,
    outline: true,
    indicator: {
      error: 'red',
      success: '#1CBF98',
      thickness: 4
    },
    handlers: (store) =>
      new DefaultEventHandlers({
        store,
        isMultiSelectEnabled: (e: MouseEvent) => !!e.metaKey
      }),
    // eslint-disable-next-line @typescript-eslint/no-empty-function
    normalizeNodes: () => {}
  }
}

export const ActionMethodsWithConfig = {
  methods: ActionMethods,
  ignoreHistoryForActions: [
    'setDOM',
    'setNodeEvent',
    'selectNode',
    'clearEvents',
    'setOptions',
    'setIndicator'
  ] as const,
  normalizeHistory: (state: EditorState) => {
    /**
     * On every undo/redo, we remove events pointing to deleted Nodes
     */
    Object.keys(state.events).forEach((eventName) => {
      const nodeIds = Array.from(state.events[eventName as NodeEventTypes] || [])

      nodeIds.forEach((id) => {
        if (!state.nodes[id]) {
          state.events[eventName as NodeEventTypes].delete(id)
        }
      })
    })

    // Remove any invalid node[nodeId].events
    // TODO(prev): it's really cumbersome to have to ensure state.events and state.nodes[nodeId].events are in sync
    // Find a way to make it so that once state.events is set, state.nodes[nodeId] automatically reflects that (maybe using proxies?)
    Object.keys(state.nodes).forEach((id) => {
      const node = state.nodes[id]

      Object.keys(node.events).forEach((eventName) => {
        const isEventActive = !!node.events[eventName as NodeEventTypes]

        if (
          isEventActive &&
          state.events[eventName as NodeEventTypes] &&
          !state.events[eventName as NodeEventTypes].has(node.id)
        ) {
          node.events[eventName as NodeEventTypes] = false
        }
      })
    })
  }
}

export type EditorStore = SubscriberAndCallbacksFor<
  typeof ActionMethodsWithConfig,
  typeof QueryMethods
>

// eslint-disable-next-line react-refresh/only-export-components
export const useEditorStore = (
  options: Partial<Options>,
  patchListener: PatchListener<EditorState, typeof ActionMethodsWithConfig, typeof QueryMethods>
): EditorStore => {
  // TODO: fix type
  return useMethods(
    ActionMethodsWithConfig,
    {
      ...editorInitialState,
      options: {
        ...editorInitialState.options,
        ...options
      }
    },
    QueryMethods,
    patchListener
  ) as EditorStore
}
