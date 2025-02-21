/* eslint-disable @typescript-eslint/restrict-template-expressions */
import { useNode, useEditor, ROOT_NODE } from '@/Components/Designer/Layout/core'
import cx from 'classnames'
import { debounce } from 'debounce'
import { Resizable } from './Re-Resizable'
import React, { useRef, useEffect, useState, useCallback } from 'react'
import styled from 'styled-components'
import { get, set } from 'lodash'

import { isPercentage, pxToPercent, percentToPx, getElementDimensions } from './utils'

const Indicators = styled.div<{ $bound?: 'row' | 'column' }>`
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  span {
    position: absolute;
    width: 10px;
    height: 10px;
    background: #fff;
    display: block;
    box-shadow: 0px 0px 12px -1px rgba(0, 0, 0, 0.25);
    z-index: 20;
    pointer-events: none;
    &:nth-child(1) {
      ${(props: any) =>
        props.$bound
          ? props.$bound === 'row'
            ? `
                left: 50%;
                top: -5px;
                transform:translateX(-50%);
              `
            : `
              top: 50%;
              left: -5px;
              transform:translateY(-50%);
            `
          : `
              left: -5px;
              top:-5px;
            `}
    }
    &:nth-child(2) {
      right: -5px;
      top: -5px;
      display: ${(props: any) => (props.$bound ? 'none' : 'block')};
    }
    &:nth-child(3) {
      ${(props: any) =>
        props.$bound
          ? props.$bound === 'row'
            ? `
                left: 50%;
                bottom: -5px;
                transform:translateX(-50%);
              `
            : `
                bottom: 50%;
                left: -5px;
                transform:translateY(-50%);
              `
          : `
              left: -5px;
              bottom:-5px;
            `}
    }
    &:nth-child(4) {
      bottom: -5px;
      right: -5px;
      display: ${(props: any) => (props.$bound ? 'none' : 'block')};
    }
  }
`

export const Resizer = ({ propKey, children, ...props }: any) => {
  const {
    id,
    actions: { setProp },
    connectors: { connect },
    fillSpace,
    nodeWidth,
    nodeHeight,
    parent,
    active,
    inNodeContext
  } = useNode((node) => {
    const nodeWidth = get(node.data.props, propKey.width)
    const nodeHeight = get(node.data.props, propKey.height)
    return {
      parent: node.data.parent,
      active: node.events.selected && node.id !== ROOT_NODE,
      nodeWidth,
      nodeHeight,
      fillSpace: node.data.props.grow
    }
  }) as any

  const { enabled, outline, isRootNode, parentDirection } = useEditor((state, query) => {
    return {
      parentDirection: parent && state.nodes[parent] && state.nodes[parent].data.props.direction,
      isRootNode: query.node(id).isRoot(),
      enabled: state.options.enabled,
      outline: state.options.outline
    }
  })

  const resizable = useRef<Resizable | null>(null)
  const isResizing = useRef<boolean>(false)
  const editingDimensions = useRef<{ width: number; height: number } | null>(null)
  const nodeDimensions = useRef<any>(null)
  nodeDimensions.current = { width: nodeWidth, height: nodeHeight }

  /**
   * Using an internal value to ensure the width/height set in the node is converted to px
   * because for some reason the <re-resizable /> library does not work well with percentages.
   */
  const [internalDimensions, setInternalDimensions] = useState({
    width: nodeWidth,
    height: nodeHeight
  })

  const updateInternalDimensionsInPx = useCallback(() => {
    const { width: nodeWidth, height: nodeHeight } = nodeDimensions.current
    const width = percentToPx(
      nodeWidth,
      (resizable.current &&
        resizable.current.resizable &&
        getElementDimensions(resizable.current.resizable.parentElement!).width)!
    )
    const height = percentToPx(
      nodeHeight,
      (resizable.current &&
        resizable.current.resizable &&
        getElementDimensions(resizable.current.resizable.parentElement!).height)!
    )

    setInternalDimensions({
      width,
      height
    })
  }, [])

  const updateInternalDimensionsWithOriginal = useCallback(() => {
    const { width: nodeWidth, height: nodeHeight } = nodeDimensions.current
    setInternalDimensions({
      width: nodeWidth,
      height: nodeHeight
    })
  }, [])

  const getUpdatedDimensions = (width: string | number, height: string | number) => {
    const dom = resizable.current?.resizable
    if (!dom) return

    const currentWidth = editingDimensions.current?.width,
      currentHeight = editingDimensions.current?.height
    if (!currentHeight || !currentWidth) return
    return {
      width: currentWidth + parseInt(String(width)),
      height: currentHeight + parseInt(String(height))
    }
  }

  useEffect(() => {
    if (!isResizing.current) updateInternalDimensionsWithOriginal()
  }, [nodeWidth, nodeHeight, updateInternalDimensionsWithOriginal])

  useEffect(() => {
    const listener = debounce(updateInternalDimensionsWithOriginal, 1)
    window.addEventListener('resize', listener)

    return () => {
      window.removeEventListener('resize', listener)
    }
  }, [updateInternalDimensionsWithOriginal])

  const outlineClassnames = outline
    ? 'outline outline-solid outline-yellow-600 -outline-offset-[1px] transition-[padding]'
    : ''
  const classNames = enabled
    ? 'hover:bg-yellow-500/10 hover:outline hover:outline-red-600/20 ' + outlineClassnames
    : ''

  return (
    <Resizable
      enable={[
        'top',
        'left',
        'bottom',
        'right',
        'topLeft',
        'topRight',
        'bottomLeft',
        'bottomRight'
      ].reduce((acc: Record<string, boolean>, key) => {
        acc[key] = active && inNodeContext
        return acc
      }, {})}
      className={cx([
        classNames,
        {
          'm-auto': isRootNode
        }
      ])}
      ref={(ref) => {
        if (ref) {
          resizable.current = ref
          connect(resizable.current.resizable!)
        }
      }}
      size={internalDimensions}
      onResizeStart={(e: Event) => {
        updateInternalDimensionsInPx()
        e.preventDefault()
        e.stopPropagation()
        const dom = resizable.current?.resizable
        const size = resizable.current?.size
        if (!dom || !size) return
        editingDimensions.current = {
          width: size?.width, // dom.getBoundingClientRect().width,
          height: size?.height // dom.getBoundingClientRect().height
        }
        isResizing.current = true
      }}
      onResize={(
        _: any,
        __: any,
        ___: any,
        d: { width: string | number; height: string | number }
      ) => {
        const dom = resizable.current?.resizable
        if (!dom) return
        let { width, height }: { width: number | string; height: number | string } =
          getUpdatedDimensions(d.width, d.height)!
        if (isPercentage(nodeWidth))
          width = `${pxToPercent(width, getElementDimensions(dom.parentElement!).width)}%`
        else width = `${width}px`

        if (isPercentage(nodeHeight))
          height = `${pxToPercent(height, getElementDimensions(dom.parentElement!).height)}%`
        else height = `${height}px`

        if (isPercentage(width) && dom.parentElement?.style.width === 'auto') {
          width = `${(editingDimensions.current?.width || 0) + (d.width as number)}px`
        }

        if (isPercentage(height) && dom.parentElement?.style.height === 'auto') {
          height = `${(editingDimensions.current?.height || 0) + (d.height as number)}px`
        }

        setProp((prop: any) => {
          set(prop, propKey.width, width)
          set(prop, propKey.height, height)
        }, 500)
      }}
      onResizeStop={() => {
        isResizing.current = false
        updateInternalDimensionsWithOriginal()
      }}
      {...props}>
      {children}
      {active && (
        <Indicators $bound={fillSpace === 'yes' ? parentDirection : false}>
          <span className="border-blue-500 border-2"></span>
          <span className="border-blue-500 border-2"></span>
          <span className="border-blue-500 border-2"></span>
          <span className="border-blue-500 border-2"></span>
        </Indicators>
      )}
    </Resizable>
  )
}
