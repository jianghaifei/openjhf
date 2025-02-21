import { ERROR_RESOLVER_NOT_AN_OBJECT, HISTORY_ACTIONS } from '@/Components/Designer/Layout/utils';
import React, { useEffect, useRef } from 'react';

import { EditorContext } from './EditorContext';
import { useEditorStore } from './store';

import { Events } from '../events';
import { Options } from '../interfaces';

/**
 * A React Component that provides the Editor context
 */
export const Editor: React.FC<React.PropsWithChildren<Partial<Options>>> = ({
  children,
  ...options
}) => {
  // we do not want to warn the user if no resolver was supplied
  if (options.resolver !== undefined) {
    if (!(typeof options.resolver === 'object' && !Array.isArray(options.resolver))) {
      console.warn(ERROR_RESOLVER_NOT_AN_OBJECT)
    }
  }

  const optionsRef = useRef(options);

  const context = useEditorStore(
    optionsRef.current,
    (state: { options: { normalizeNodes: (arg0: any, arg1: any, arg2: any, arg3: any) => void; }; }, previousState: any, actionPerformedWithPatches: { [x: string]: any; patches: any; }, query: any, normalizer: (arg0: (draft: any) => void) => void) => {
      if (!actionPerformedWithPatches) {
        return;
      }

      const { patches, ...actionPerformed } = actionPerformedWithPatches;

      for (let i = 0; i < patches.length; i++) {
        const { path } = patches[i];
        const isModifyingNodeData =
          path.length > 2 && path[0] === 'nodes' && path[2] === 'data';

        const actionType = actionPerformed.type;

        if (
          [HISTORY_ACTIONS.IGNORE, HISTORY_ACTIONS.THROTTLE].includes(
            actionType
          ) &&
          actionPerformed.params
        ) {
          actionPerformed.type = actionPerformed.params[0];
        }

        if (
          ['setState', 'deserialize'].includes(actionPerformed.type) ||
          isModifyingNodeData
        ) {
          normalizer((draft) => {
            if (state.options.normalizeNodes) {
              state.options.normalizeNodes(
                draft,
                previousState,
                actionPerformed,
                query
              );
            }
          });
          break; // we exit the loop as soon as we find a change in node.data
        }
      }
    }
  );

  // sync enabled prop with editor store options
  useEffect(() => {
    if (!context || !options) {
      return;
    }

    if (
      options.enabled === undefined ||
      context.query.getOptions().enabled === options.enabled
    ) {
      return;
    }

    if (options.scale) {
      context.actions.setOptions((editorOptions) => {
        editorOptions.scale = options.scale
      })
    }

    context.actions.setOptions((editorOptions) => {
      editorOptions.enabled = options.enabled;
    });
  }, [context, options]);

  useEffect(() => {
    context.subscribe(
      () => ({
        json: context.query.serialize(),
      }),
      () => {
        context.query.getOptions().onNodesChange(context.query);
      }
    );
  }, [context]);

  return context ? (
    <EditorContext.Provider value={context}>
      {1}
      <Events>{children}</Events>
    </EditorContext.Provider>
  ) : null;
};
