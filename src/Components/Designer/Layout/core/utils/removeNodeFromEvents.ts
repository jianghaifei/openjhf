import { EditorState, NodeId } from '../interfaces';

import { EditorEvents } from '../interfaces';
export const removeNodeFromEvents = (state: EditorState, nodeId: NodeId) =>
  Object.keys(state.events).forEach((key) => {
    const eventSet = state.events[key as keyof EditorEvents];
    if (eventSet && eventSet.has && eventSet.has(nodeId)) {
      state.events[key as keyof EditorEvents] = new Set(
        Array.from(eventSet).filter((id) => nodeId !== id)
      );
    }
  });
