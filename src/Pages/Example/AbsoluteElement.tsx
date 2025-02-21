import { IComponentSchema } from '@/Model/IScema'
import * as React from 'react'
import Moveable from 'react-moveable'
import { ReactComponent as ArmChairSVG } from './ArmChair.svg'
import { useEditor, useNode } from '@/Components/Designer/Layout/core'
import classNames from 'classnames'
import './AbsoluteElement.css'

export const AbsoluteElement = React.forwardRef((props: React.PropsWithChildren<any>, ref) => {
  const targetRef = React.useRef<HTMLDivElement>(null)
  const { id, parent } = useNode((state) => {
    return {
      parent: state.data.parent
    }
  }) as any
  React.useEffect(() => {
    typeof ref === 'function' && ref(targetRef.current)
  }, [ref, targetRef])
  const { enabled, isActive } = useEditor((state, query) => {
    return {
      isActive: query.getEvent('selected').contains(id),
      enabled: state.options.enabled
    }
  })
  const { actions, prop } = useNode((state) => {
    return {
      prop: state.data.props
    }
  }) as any

  const layout = prop.layout || {}

  return (
    <>
      <div
        className={classNames(
          'target absolute-element pointer-events-auto absolute outline-gray-700 outline-2 outline',
          isActive ? 'z-50' : 0
        )}
        ref={targetRef}
        style={{
          ...prop.style,
          width: layout.width,
          height: layout.height,
          transform: `translate(${(layout.left || 0) as number}px, ${
            (layout.top || 0) as number
          }px) rotate(0deg)`
        }}>
        {props.children || 'Target'}
      </div>
      <Moveable
        target={enabled && isActive ? targetRef : null}
        draggable={true}
        className="absolute-container"
        throttleDrag={1}
        edgeDraggable={false}
        startDragRotate={0}
        throttleDragRotate={0}
        onDrag={(e) => {
          e.target.style.transform = e.transform
        }}
        onDragEnd={(e) => {
          const rect = e.moveable.getRect()
          actions.setProp((prop: any) => {
            prop.layout = prop.layout || {}
            prop.layout.top = `${rect.top}px`
            prop.layout.left = `${rect.left}px`
          })
        }}
        resizable={true}
        keepRatio={false}
        throttleResize={1}
        renderDirections={['nw', 'ne', 'sw', 'se']}
        onResize={(e) => {
          e.target.style.width = `${e.width}px`
          e.target.style.height = `${e.height}px`
          e.target.style.transform = e.drag.transform
        }}
        onResizeEnd={(e) => {
          const rect = e.moveable.getRect()
          e.target.style.width = `${rect.width}px`
          e.target.style.height = `${rect.height}px`
          // e.target.style.transform = e.drag.transform
          actions.setProp((prop: any) => {
            prop.layout = prop.layout || {}
            prop.layout.width = `${rect.width}px`
            prop.layout.height = `${rect.height}px`
            prop.layout.top = `${rect.top}px`
            prop.layout.left = `${rect.left}px`
          })
        }}
        rotatable={true}
        throttleRotate={0}
        rotationPosition={'top'}
        onRotate={(e) => {
          e.target.style.transform = e.drag.transform
        }}
        snappable={true}
        isDisplaySnapDigit={true}
        isDisplayInnerSnapDigit={false}
        snapGap={true}
        snapDirections={{
          top: true,
          left: true,
          bottom: true,
          right: true,
          center: true,
          middle: true
        }}
        elementSnapDirections={{
          top: true,
          left: true,
          bottom: true,
          right: true,
          center: true,
          middle: true
        }}
        scalable={true}
        snapThreshold={5}
        elementGuidelines={['.absolute-element', '.custom-container']}
        bounds={{ left: 0, top: 0, right: 0, bottom: 0, position: 'css' }}
      />
    </>
  )
})

export const AbsoluteElementSchema: IComponentSchema = {
  basic: {
    name: 'Absolute Element',
    description: 'Absolute Element, Absolute',
    type: 'AbsoluteElement',
    package: '@cyrilis/flame',
    version: '0.0.20',
    icon: <ArmChairSVG></ArmChairSVG>
  },
  layout: {
    width: 4,
    height: 9,
    resizable: true,
    dropable: true,
    dragable: true,
    absolute: true,
    canvas: true
  },
  properties: []
}
