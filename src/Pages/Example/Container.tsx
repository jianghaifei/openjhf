import { useEditor, useNode } from '@/Components/Designer/Layout/core'
import { ReactComponent as RectSVG } from './RectangleLine.svg'
import { IComponentLayoutSchema, IComponentSchema } from '@/Model/IScema'
import classNames from 'classnames'
import { PropsWithChildren } from 'react'

interface Prop {
  id: string
  layout: IComponentLayoutSchema
  style: Record<string, string>
}

export const Container = (prop: PropsWithChildren<Prop>) => {
  const { enabled, outline, gap } = useEditor((state) => {
    return {
      enabled: state.options.enabled,
      outline: state.options.outline,
      gap: state.options.gap
    }
  })

  const { id } = useNode()

  return (
    <div
      className={classNames(
        'flex custom-container relative transition-all',
        prop.layout.direction === 'row' ? 'flex-row' : 'flex-col',
        prop.layout.grow ? 'flex-grow' : 'flex-grow-0',
        outline && enabled ? 'outline outline-solid outline-purple-600 -outline-offset-[1px]' : '',
        gap ? 'p-2' : ''
      )}
      style={{ ...prop.style, width: prop.layout.width, height: prop.layout.height }}
      data-id={id}>
      {prop.children}
    </div>
  )
}

export const ContainerSchema: IComponentSchema = {
  basic: {
    name: '基础容器',
    description: 'Flex Container',
    type: 'Container',
    package: '@cyrilis/flame',
    version: '0.0.20',
    icon: <RectSVG></RectSVG>
  },
  layout: {
    width: 4,
    height: 9,
    resizable: true,
    dropable: true,
    dragable: true,
    canvas: true
  },
  properties: []
}

export const ContainerCraft = {
  displayName: 'Container',
  isCanvas: true,
  rules: {
    canDrag: () => {
      return true
    },
    canDrop: () => {
      return true
    }
  }
}
