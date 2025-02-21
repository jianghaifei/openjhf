import { useNode } from '@/Components/Designer/Layout/core'
import { IComponentSchema } from '@/Model/IScema'
import classNames from 'classnames'
import { useEffect } from 'react'

export const ComponentWrapper = (
  Element: JSX.ElementType,
  schema?: IComponentSchema
): JSX.ElementType => {
  const NewElement = (prop: Record<string, any>) => {
    const { style, ...otherProp } = prop
    const {
      connectors: { connect }
    } = useNode() as any

    const absolute = schema?.layout.absolute === true

    return absolute ? (
      <Element ref={connect} {...prop}></Element>
    ) : (
      <div
        ref={connect}
        className={classNames(
          'component-wrapper flex flex-col',
          absolute ? 'absolute top-0 left-0' : ''
        )}
        style={{
          ...style,
          width: absolute ? 0 : otherProp.layout.width,
          height: absolute ? '0' : otherProp.layout.height
        }}>
        <Element {...otherProp}></Element>
      </div>
    )
  }
  return NewElement
}
