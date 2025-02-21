import { IComponent, IComponentLayout } from '../Model/IComponent'
import { makeAutoObservable, observable } from 'mobx'
import { ICommonConfig } from '../Model/ICommonModel'
import PageModel, { IComponentModel } from './PageModel'
import BasicComponentModel from './BasicComponentModel'
import ComponentHelper from '@/Utils/ComponentHelper'
import { IComponentProperties, IComponentPropsSchema } from '@/Model/IScema'
import { parseProperty2Object } from '@/Utils/Utils'
import { ComponentCreator } from '@/Runtime/ComponentCreator'
import { merge, omit } from 'lodash'

export default class ContainerModel {
  componentInfo: IComponent
  parent: PageModel | ContainerModel | null
  children: IComponentModel[] = [] //这里是一个一维数组，不是一个树形结构，方便进行操作

  constructor(info: IComponent, parent: PageModel | ContainerModel) {
    makeAutoObservable(this, {
      parent: observable.ref
      // children: observable.ref,
    })
    this.componentInfo = JSON.parse(JSON.stringify(info))
    this.parent = parent
    this.children = []
    this.initProps()
    this.appendComponents(info.children)
  }

  get properties() {
    const properties = ComponentHelper.getFieldByType(this.componentInfo.type, 'properties') as
      | IComponentProperties[]
      | IComponentPropsSchema[]
    return properties
  }

  initProps() {
    this.componentInfo.props = merge(
      {},
      omit(parseProperty2Object(this.properties), ['layout']),
      this.componentInfo.props
    )
  }

  appendComponents(kids: IComponent[] | null): (BasicComponentModel | ContainerModel)[] {
    if (null === kids) {
      return []
    }

    if (!this.children) {
      this.children = []
    }

    kids.map((child: IComponent) => {
      this.children.push(ComponentCreator(child, this))
      // this.children.push(new BasicComponentModel(child, this));
      // if (child.type === ComponentType.FreeContainer) {
      //   this.appendComponents([child]);
      // }
    })

    return this.children
  }

  deleteComponent(item: BasicComponentModel): BasicComponentModel[] {
    if (this.children === null || this.children.length === 0) {
      return []
    }

    for (let i = 0; i < this.children.length; i++) {
      const child: BasicComponentModel = this.children[i]
      if (item.componentInfo.id === child.componentInfo.id) {
        this.children.splice(i, 1)
      }
    }

    return this.children
  }

  setProperty(id: string, property: ICommonConfig): void {
    if (id !== this.componentInfo.id) {
      return
    }
    this.componentInfo.style = { ...this.componentInfo.props, ...property }
  }

  setStyle(id: string, style: ICommonConfig) {
    if (id !== this.componentInfo.id) {
      return
    }
    this.componentInfo.style = { ...this.componentInfo.style, ...style }
  }

  getMetadata(): IComponent {
    return {
      ...this.componentInfo,
      children: this.children.map((item: BasicComponentModel) => {
        return { ...item.getMetadata() }
      })
    }
  }

  changeLayout(layout: IComponentLayout) {
    this.componentInfo.layout = { ...this.componentInfo.layout, ...layout }
  }
}
