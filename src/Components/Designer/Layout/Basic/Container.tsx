import React from 'react'
import { merge } from 'lodash'
import { Resizer } from './Resizer'
import { useEditor, useNode } from '@/Components/Designer/Layout/core'
import { ReactComponent as ScissorsSVG } from '@/assets/Container/scissors.svg'
import { Tooltip } from '@douyinfe/semi-ui'
import { createNode } from '@/Components/Designer/Layout/core/utils/createNode'

export type ContainerProps = {
  direction: string
  alignItems: string
  justifyContent: string
  border: string
  width: string
  layout: {
    width: string
    height: string
    direction?: string
    grow?: boolean
    shrink?: boolean
    padding?: string
    margin?: string
  }
  style: Record<string, string>
  padding: string
  margin: string
  grow: boolean
  shrink: boolean
  children: React.ReactNode
  radius: number
}

const defaultProps = {
  direction: 'column',
  alignItems: 'flex-start',
  justifyContent: 'flex-start',
  padding: '',
  margin: '',
  grow: false,
  radius: 0,
  layout: {
    width: '100%',
    height: 'auto'
  }
}

export const Container = (props: Partial<ContainerProps>) => {
  props = merge({
    ...defaultProps,
    ...props
  })

  const { enabled, skew, gap, actions } = useEditor((state) => {
    return {
      enabled: state.options.enabled,
      skew: state.options.skew,
      gap: state.options.gap
    }
  })

  const {
    alignItems,
    justifyContent,
    // direction,
    // grow,
    // shrink,
    // padding,
    // margin,
    border,
    radius,
    style,
    children
  } = props
  const layout = props.layout

  const { direction, grow, shrink, padding, margin } = layout || {}

  const _style = Object.assign({}, style) || {}
  _style.flexShrink = shrink ? '1' : 'unset'
  _style.flexGrow = grow ? '1' : 'unset'
  if (skew) {
    _style.transition = 'transform .5s'
    _style.transform = 'translate(50px, -50px)'
    _style.border = '1px solid orange'
    _style.background = 'rgba(255, 140, 0, .1)'
  }
  let _padding = padding
  if (enabled && gap && (!padding || padding === '0')) {
    _padding = '5px'
  }
  const node = useNode((node) => {
    return node
  })
  const split = (vertical: boolean) => {
    return () => {
      console.log('Node Data: ', node, vertical)
      const first = createNode({
        data: {
          custom: {},
          parent: node.id,
          displayName: 'Container',
          hidden: false,
          isCanvas: true,
          linkedNodes: {},
          name: 'Container',
          nodes: [],
          props: {
            layout: {
              direction: 'column',
              width: vertical ? '50%' : '100%',
              height: vertical ? '100%' : '50%',
              grow: false,
              padding: '0',
              margin: '0'
            }
          },
          type: Container
        }
      })
      const second = createNode({
        data: {
          custom: {},
          parent: node.id,
          displayName: 'Container',
          hidden: false,
          isCanvas: true,
          linkedNodes: {},
          name: 'Container',
          nodes: [],
          props: {
            layout: {
              direction: 'column',
              width: vertical ? 'auto' : '100%',
              height: vertical ? '100%' : 'auto',
              grow: true,
              padding: '0',
              margin: '0'
            }
          },
          type: Container
        }
      })
      actions.setProp(node.id, (prop) => {
        prop.layout.direction = vertical ? 'row' : 'column'
      })
      actions.add([first, second], node.id)
    }
  }

  return (
    <Resizer
      propKey={{ width: 'layout.width', height: 'layout.height' }}
      style={{
        display: 'flex',
        justifyContent,
        flexDirection: direction,
        alignItems,
        padding: _padding,
        margin,
        border,
        borderRadius: `${radius!}px`,
        ..._style
      }}>
      {children
        ? children
        : enabled && (
            <div className="flex flex-col w-full h-full relative group/container">
              <div className="absolute flex justify-center w-full h-full pointer-events-none bg-gray-100">
                <div className="flex justify-center w-5 h-full">
                  <div className="w-[2px] h-full border-blue-600 opacity-0 group-hover/container:opacity-10 border-dashed border-r-2"></div>
                  <Tooltip content={'Split container vertical'}>
                    <div className="w-5 h-5 group-hover/container:opacity-100 opacity-0 absolute top-[15%] z-10 [&:hover>svg]:opacity-100">
                      <div className="w-4 h-4 rounded-full bg-white shadow-sm border absolute top-[4px] left-[2px]"></div>
                      <ScissorsSVG
                        className="bg-white rounded-full p-[2px] opacity-0 text-blue-600 pointer-events-auto cursor-pointer w-5 -rotate-90 absolute top-[15%] z-10"
                        onClick={split(true)}></ScissorsSVG>
                    </div>
                  </Tooltip>
                </div>
              </div>
              <div className="absolute flex justify-center items-center w-full h-full pointer-events-none">
                <div className="flex items-center h-5 w-full ">
                  <div className="h-[2px] w-full border-blue-600 opacity-0 group-hover/container:opacity-10 border-dashed border-t-2"></div>
                  <Tooltip content={'Split container horizontal'}>
                    <div className="w-5 h-5 group-hover/container:opacity-100 opacity-0 absolute left-[15%] z-10 [&:hover>svg]:opacity-100">
                      <div className="w-4 h-4 rounded-full bg-white shadow-sm border absolute top-[2px] left-[4px]"></div>
                      <ScissorsSVG
                        className="bg-white rounded-full p-[2px] opacity-0 text-blue-600 pointer-events-auto cursor-pointer w-5 absolute left-[15%] z-10"
                        onClick={split(false)}></ScissorsSVG>
                    </div>
                  </Tooltip>
                </div>
              </div>
              <div className="absolute w-full h-full flex items-center justify-center text-gray-400 space-x-[2px]">
                <div className="font-mono">{props.layout?.width}</div>
                <div className="font-mono">×</div>
                <div className="font-mono">{props.layout?.height}</div>
              </div>
            </div>
          )}
    </Resizer>
  )
}

export const ContainerCraft = {
  displayName: 'Container',
  props: defaultProps,
  rules: {
    canDrag: () => {
      return true
    },
    canDrop: () => {
      return true
    }
  }
}

// Object.defineProperty(Container, 'name', { value: 'Container' })
// Object.defineProperty(Container, 'craft', { value: craft })
