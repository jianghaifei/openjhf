import { makeAutoObservable } from 'mobx'
import { IPageMetadata } from '../Model/IPageMetadata'
import BasicComponentModel from './BasicComponentModel'
import { IComponent } from '../Model/IComponent'
import { ICommonConfig } from '../Model/ICommonModel'
import { ComponentCreator } from '../Runtime/ComponentCreator'
import PropertyType from '../Constants/PropertyType'
import ComponentType from '../Constants/ComponentType'
import ContainerModel from './ContainerModel'
import { IComponentProperties, IComponentPropsSchema } from '@/Model/IScema.ts'
import { parseProperty2Object } from '@/Utils/Utils.ts'

export type IComponentModel = BasicComponentModel | ContainerModel
export default class PageModel {
  pageMetadata: IPageMetadata | null
  components: IComponentModel[]

  get propsSchema(): IComponentProperties[] | IComponentPropsSchema[] {
    return [
      {
        key: 'title',
        title: '标题',
        description: '设置标题',
        setter: {
          type: ComponentType.Input,
          editable: true
        },
        extensions: {
          placeholder: '请输入标题'
        },
        valueType: 'string'
      },
      {
        key: 'route',
        title: '页面路由',
        description: '请输入页面路由',
        setter: {
          type: ComponentType.Input,
          editable: true
        },
        extensions: {
          placeholder: '请输入路由'
        },
        valueType: 'string'
      }
    ]
  }

  get defaultProps(): ICommonConfig {
    return {
      ...parseProperty2Object(this.propsSchema),
      ...(this.pageMetadata?.props || {})
    }
  }
  get defaultStyle(): ICommonConfig {
    return {
      ...(this.pageMetadata?.style || {})
    }
  }

  constructor(data: IPageMetadata | null) {
    makeAutoObservable(this)
    //deep clone，待替换
    this.components = []
    this.pageMetadata = null
    if (data != null) {
      this.pageMetadata = JSON.parse(JSON.stringify(data))
      this.appendComponents(data.componentsTree)
    }
  }

  setData(data: IPageMetadata) {
    this.components = []
    this.pageMetadata = JSON.parse(JSON.stringify(data))
    this.appendComponents(data.componentsTree)
  }

  private _createComponents(kids: IComponent[] | null): IComponentModel[] {
    if (kids == null || kids.length <= 0) {
      return []
    }

    const components: IComponentModel[] = []
    kids.forEach((Item: IComponent) => {
      const el = ComponentCreator(Item, this)
      components.push(el)
    })

    return components
  }

  appendComponents(kids: IComponent[]): IComponentModel[] {
    const list = this._createComponents(kids)
    this.components = [...this.components, ...list]
    return list
  }

  deleteComponent(item: IComponentModel) {
    const idx: number = this.components.indexOf(item)
    if (idx >= 0) {
      this.components.splice(idx, 1)
      this.components = [...this.components]
    }
  }

  getComponentByID(id: string): IComponentModel | null | undefined {
    if (id === this.pageMetadata?.id) {
      return null
    }
    const stepOver = (item: any): IComponentModel | undefined => {
      const children: IComponentModel[] = item.children || []
      let target
      children.find((child: any) => {
        let _id
        if (child.componentInfo) {
          _id = child.componentInfo.id
        }
        if (_id === id) {
          target = child
        } else {
          const _target = stepOver(child)
          if (_target) {
            target = _target
          }
        }
      })
      return target
    }
    return stepOver({ children: this.components })
  }

  setProperty(id: string, type: PropertyType, property: ICommonConfig): void {
    if (id === '' && this.pageMetadata) {
      if (type === PropertyType.PropertyType_Props) {
        this.pageMetadata.props = { ...this.pageMetadata.props, ...property }
      } else if (type === PropertyType.PropertyType_Style) {
        this.pageMetadata.style = { ...this.pageMetadata.style, ...property }
      }
    } else {
      const element = this.getComponentByID(id)
      element && element.setProperty(id, property)
    }
  }

  getPageMetadata(): IPageMetadata | null {
    if (!this.pageMetadata) {
      return null
    }
    const components: IComponent[] = this.components?.map((item: IComponentModel) => {
      return item.getMetadata()
    })
    return {
      ...this.pageMetadata,
      componentsTree: components
    }
  }
}
