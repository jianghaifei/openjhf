import { IComponent, IComponentLayout } from '../Model/IComponent'
import { makeAutoObservable, observable } from 'mobx'
import { ICommonConfig } from '../Model/ICommonModel'
import PageModel from '../ViewModel/PageModel'
import ContainerModel from '../ViewModel/ContainerModel'
import ComponentHelper from '../Utils/ComponentHelper.ts'
import { IComponentProperties, IComponentPropsSchema } from '../Model/IScema'
import { parseProperty2Object } from '@/Utils/Utils.ts'
import { merge } from 'lodash'

export default class BasicComponentModel {
  componentInfo: IComponent
  parent: PageModel | ContainerModel | null

  constructor(info: IComponent, parent: PageModel | ContainerModel) {
    makeAutoObservable(this, {
      parent: observable.ref
    })
    //deep clone,待替换
    this.componentInfo = JSON.parse(JSON.stringify(info))
    this.parent = parent
    this.initProps()
  }

  get properties() {
    return ComponentHelper.getFieldByType(this.componentInfo.type, 'properties') as
      | IComponentProperties[]
      | IComponentPropsSchema[]
  }

  initProps() {
    this.componentInfo.props = merge(
      {},
      parseProperty2Object(this.properties),
      this.componentInfo.props
    )
  }

  // setProperty(id: string, type: PropertyType, property: ICommonConfig): void {
  //   if (id != this.componentInfo.id) {
  //     return;
  //   }

  //   if (type === PropertyType.PropertyType_Props) {
  //     this.componentInfo.props = { ...this.componentInfo.props, ...property };
  //   } else if (type === PropertyType.PropertyType_Style) {
  //     this.componentInfo.style = { ...this.componentInfo.style, ...property };
  //   }
  // }

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
      ...this.componentInfo
    }
  }

  changeLayout(layout: IComponentLayout) {
    this.componentInfo.layout = { ...this.componentInfo.layout, ...layout }
  }
}
