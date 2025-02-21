import { useEditor, useNode } from '@/Components/Designer/Layout/core'
import { Resizer } from '@/Components/Designer/Layout/Basic/Resizer'
import { IComponentSchema } from '@/Model/IScema'

export const componentWrapper = (Component: JSX.ElementType, schema?: IComponentSchema) => {
  return function (prop: Record<string, any>) {
    const { style: style, children, ...componentProps } = prop
    const {
      connectors: { connect, drag }
    } = useNode() as any

    const { skew } = useEditor((state) => {
      return {
        skew: state.options.skew
      }
    })

    const absolute = schema?.layout.absolute === true

    const _style = Object.assign({}, style)
    if (skew) {
      _style.transition = 'transform .5s'
      _style.transform = 'translate(50px, -50px)'
      _style.border = '1px solid red'
      _style.background = 'rgba(255, 0, 0, .1)'
    }

    const { layout } = prop
    const { direction, grow, shrink, padding, margin } = layout || {}

    return absolute ? (
      <Component
        ref={(dom: any) => {
          connect(dom)
        }}
        data-id={prop.id}
        data-name={prop.name}
        {...componentProps}
        style={{ ...style }}>
        {children}
      </Component>
    ) : (
      <Resizer
        propKey={{ width: 'layout.width', height: 'layout.height' }}
        style={{
          display: 'flex',
          position: 'relative',
          flexDirection: direction,
          flexGrow: grow ? '1' : 'unset',
          flexShrink: shrink ? '1' : 'unset',
          padding,
          margin,
          maxWidth: '100%',
          ..._style
        }}>
        <Component data-id={prop.id} data-name={prop.name} {...componentProps} style={{ ...style }}>
          {children}
        </Component>
      </Resizer>
    )
  }
}
