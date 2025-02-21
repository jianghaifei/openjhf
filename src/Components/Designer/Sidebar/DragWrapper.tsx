import { IComponentSchema } from '@/Model/IScema'
import { Fragment, PropsWithChildren } from 'react'
import { useEditor, Element } from '@/Components/Designer/Layout/core'
import { parseProperty2Object } from '@/Utils/Utils'
import ComponentHelper from '@/Utils/ComponentHelper'
import { defaultsDeep } from 'lodash'

interface Prop {
  type: string
  component: JSX.ElementType
  schema: IComponentSchema
  props?: any
}

export const DragWrapper = (prop: PropsWithChildren<Prop>) => {
  const {
    scale,
    actions,
    query,
    connectors: { create }
  } = useEditor((state) => {
    return {
      scale: state.options.scale
    }
  })

  let props = parseProperty2Object(prop.schema.properties)

  props = defaultsDeep(props, {
    layout: {
      width: 'auto',
      height: 'auto',
      direction: 'column'
    }
  })

  if (prop.props) {
    props = defaultsDeep(prop.props, props)
  }

  const schema = prop.schema
  return (
    <div
      className="w-1/3 flex flex-col items-center justify-around h-[80px] cursor-pointer hover:shadow-xl"
      ref={(ref) => {
        const canvas = schema.layout.canvas === true
        return create(ref!, <Element canvas={canvas} is={prop.component} {...props}>3</Element>, {
          onCreate: (nodeTree, e) => {
            const id = nodeTree.rootNodeId
            actions.selectNode(id)
            const nodes = query.getNodes()
            const node = nodes[id]
            if (node && node.data.parent && node.data.custom.absolute) {
              const parent = node.data.parent
              const dom = nodes[parent].dom
              if (dom) {
                const rect = dom.getBoundingClientRect()
                console.log(e.clientY, rect.top, e.clientY - rect.top)
                actions.history.throttle(10).setProp(id, (prop) => {
                  prop.layout.left = (e.clientX - rect.left) / scale
                  prop.layout.top = (e.clientY - rect.top) / scale
                })
              }
            }
          }
        })
      }}>
      <div className="w-[50px] h-[36px] flex justify-center items-center">
        {typeof schema.basic.icon === 'string' ? (
          schema.basic.icon.startsWith('icon') ? (
            <i className={`iconfont ${schema.basic.icon} text-3xl`} />
          ) : (
            <div
              style={{ width: '28px' }}
              dangerouslySetInnerHTML={{ __html: schema.basic.icon }}></div>
          )
        ) : (
          <div className="w-[28px]">{schema.basic.icon}</div>
        )}
      </div>
      <div className="text-center text-sm">{schema.basic.name}</div>
    </div>
  )
}

interface MenuProp {
  type: string
  prop?: any
}

export const SidebarMenuList = (prop: { prop: MenuProp[] }) => {
  const components = ComponentHelper.components
  const schemas = ComponentHelper.componentSchemas

  return (
    <>
      {prop.prop.map((prop, idx) => {
        const component = components[prop.type]
        const schema = schemas[prop.type]
        if (!component || !schema) {
          return <Fragment key={idx}></Fragment>
          // throw new Error('component with type: ' + prop.type + ' is not registered!')
        }
        return (
          <DragWrapper
            key={idx}
            type={prop.type}
            component={component}
            schema={schema}
            props={prop.prop}></DragWrapper>
        )
      })}
    </>
  )
}
