import { getRandomId as getRandomNodeId } from '@/Components/Designer/Layout/utils'
import React from 'react'

import { Node, FreshNode, UserComponentConfig, NodeRules } from '../interfaces'
import {
  defaultElementProps,
  Element,
  Canvas,
  elementPropToNodeData,
  deprecateCanvasComponent
} from '../nodes'
import { NodeProvider } from '../nodes/NodeContext'

const getNodeTypeName = (type: string | { name: string }) =>
  typeof type == 'string' ? type : type.name

export function createNode(newNode: FreshNode, normalize?: (node: Node) => void) {
  let actualType = newNode.data.type as any
  const id = newNode.id || getRandomNodeId()

  const node: Node = {
    id,
    _hydrationTimestamp: Date.now(),
    data: {
      name: getNodeTypeName(actualType),
      displayName: getNodeTypeName(actualType),
      props: {
        id
      },
      custom: {},
      parent: null,
      isCanvas: false,
      hidden: false,
      nodes: [],
      linkedNodes: {},
      ...newNode.data
    },
    related: {},
    events: {
      selected: false,
      dragged: false,
      hovered: false
    },
    rules: {
      canDrag: () => true,
      canDrop: () => true,
      canMoveIn: () => true,
      canMoveOut: () => true
    },
    dom: null
  }

  if (node.data.type === Element || node.data.type === Canvas) {
    const mergedProps: Record<string, any> = {
      ...defaultElementProps,
      ...node.data.props
    }

    node.data.props = Object.keys(node.data.props).reduce((props, key: string) => {
      if (Object.keys(defaultElementProps).includes(key)) {
        // If a <Element /> specific props is found (ie: "is", "canvas")
        // Replace the node.data with the value specified in the prop
        const idxKey = (elementPropToNodeData as Record<string, any>)[key] || key
        const data = node.data as Record<string, any>
        data[idxKey] = mergedProps[key]
      } else {
        // Otherwise include the props in the node as usual
        // eslint-disable-next-line @typescript-eslint/no-extra-semi
        ;(props as Record<string, any>)[key] = node.data.props[key]
      }

      return props
    }, {})

    actualType = node.data.type
    node.data.name = getNodeTypeName(actualType)
    node.data.displayName = getNodeTypeName(actualType)

    const usingDeprecatedCanvas = node.data.type === Canvas
    if (usingDeprecatedCanvas) {
      node.data.isCanvas = true
      deprecateCanvasComponent()
    }
  }

  if (normalize) {
    normalize(node)
  }

  // TODO: use UserComponentConfig type
  const userComponentConfig = actualType.craft as UserComponentConfig<any>

  if (userComponentConfig) {
    node.data.displayName =
      userComponentConfig.displayName || userComponentConfig.name || node.data.displayName

    node.data.props = {
      ...(userComponentConfig.props || userComponentConfig.defaultProps || {}),
      ...node.data.props
    }

    node.data.custom = {
      ...(userComponentConfig.custom || {}),
      ...node.data.custom
    }

    if (userComponentConfig.isCanvas !== undefined && userComponentConfig.isCanvas !== null) {
      node.data.isCanvas = userComponentConfig.isCanvas
    }

    if (userComponentConfig.rules) {
      Object.keys(userComponentConfig.rules).forEach((key) => {
        if (['canDrag', 'canDrop', 'canMoveIn', 'canMoveOut'].includes(key)) {
          node.rules[key as keyof NodeRules] = userComponentConfig.rules[
            key as keyof NodeRules
          ] as any
        }
      })
    }

    if (userComponentConfig.related) {
      const relatedNodeContext = {
        id: node.id,
        related: true
      }

      Object.keys(userComponentConfig.related).forEach((comp) => {
        node.related[comp] = (props) =>
          React.createElement(
            NodeProvider,
            relatedNodeContext,
            React.createElement(userComponentConfig.related[comp] as any, props)
          )
      })
    }
  }

  return node
}
