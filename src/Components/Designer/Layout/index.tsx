import { CanvasFrame } from '@/Components/Designer/Layout/Canvas'
import { Editor, Element, Options } from '@/Components/Designer/Layout/core'
import { RenderNode } from '@/Components/Designer/Layout/Canvas/RenderNode'
import { Container } from './Basic/Container'
import { PropsWithChildren, useCallback, useContext, useState } from 'react'
import ComponentHelper, { IComponentWrapper } from '../../../Utils/ComponentHelper'
import StoreContext from '@/Store/storeContext.ts'
import { IPageMetadata } from '@/Model/IPageMetadata'
import { Layout } from '@douyinfe/semi-ui'
import { Zoom } from '@/Components/Designer/components/Zoom'
import throttle from 'lodash/fp/throttle'

const { Content } = Layout

export interface ProviderProp {
  RenderNode?: React.ComponentType<{ render: React.ReactElement }>
  onSchemaChange?: (schema: any) => void
  defaultEnabled?: boolean
  componentWrapper?: IComponentWrapper
  handlers?: Options['handlers']
  resolver?: Record<string, string | React.ElementType>
}

export const EditorProvider = (prop: PropsWithChildren<ProviderProp>) => {
  const { designerStore } = useContext(StoreContext)
  const [enabled] = useState(typeof prop.defaultEnabled === 'boolean' ? prop.defaultEnabled : false)

  const setupSchema = useCallback(
    (schema: string) => {
      // setSchema(schema)
      if (!designerStore.pageModel?.pageMetadata) {
        designerStore.setPageData({
          id: 'uuid',
          type: 'Page',
          props: {
            route: '/test',
            title: '测试页面'
          },
          style: {},
          componentsTree: []
        } as IPageMetadata)
      }
      const pageModel = designerStore.pageModel?.pageMetadata
      const canvasSchema = JSON.parse(schema)
      console.log('Craft Schema: ', canvasSchema)

      function parseToTree(key: string, object: any = {}) {
        const obj = canvasSchema[key]
        if (!obj) return object
        const { style, layout, ...props } = obj.props || {}
        object.id = key
        object.type = obj.type?.resolvedName // (key === 'ROOT' ? 'Page': obj.type?.resolvedName)
        object.props = props
        object.style = style || {}
        object.name = obj.displayName
        object.layout = Object.assign({}, layout, {
          canvas: obj.isCanvas
        })
        object.children = obj.nodes.map((id: string) => {
          return parseToTree(id, {})
        })
        return object
      }
      const componentTreeData = [parseToTree('ROOT', {})]

      const pageModelData: IPageMetadata = {
        id: 'page',
        type: 'Page',
        props: pageModel?.props || {},
        style: pageModel?.style || {},
        componentsTree: componentTreeData
      }
      console.log('------------------------- UPDATE MODEL --------------------')
      prop.onSchemaChange?.(pageModelData)
      designerStore.setPageData(pageModelData)
    },
    [designerStore, prop]
  )

  // eslint-disable-next-line react-hooks/exhaustive-deps
  const nodeChangeCB = useCallback(
    throttle(4 * 100)((query) => {
      setupSchema(query.serialize())
    }),
    [setupSchema]
  )
  if (prop.componentWrapper) {
    ComponentHelper.setComponentWrapper(prop.componentWrapper)
  }

  // RegisterFlame(ComponentHelper)

  const components = ComponentHelper.getComponents()

  return (
    <Editor
      enabled={enabled}
      onRender={prop.RenderNode || RenderNode}
      onNodesChange={nodeChangeCB}
      {...(prop.handlers ? { handlers: prop.handlers } : {})} // TODO: Ops... default value hack.
      resolver={prop.resolver || { ...components, Container }}>
      {prop.children}
    </Editor>
  )
}

interface Prop {
  className?: string
}

export const BareCanvas = ({ children, className }: PropsWithChildren<Prop>) => {
  return (
    <CanvasFrame className={className}>
      {children || (
        <Element
          canvas
          is={Container}
          padding={'0'}
          layout={{ width: '100%', height: '100%', direction: 'column' }}
          style={{ background: '#fff' }}
          custom={{ displayName: 'Page' }}></Element>
      )}
    </CanvasFrame>
  )
}

export const Canvas = ({ children }: PropsWithChildren) => {
  return (
    <Content className="bg-gray-100 flex overflow-auto relative group/canvas">
      <div className="absolute top-2 right-2 flex bg-white border rounded p-1 z-10 items-center transition-opacity opacity-0 group-hover/canvas:opacity-100">
        <Zoom></Zoom>
      </div>
      <BareCanvas>{children}</BareCanvas>
    </Content>
  )
}

export default Canvas
