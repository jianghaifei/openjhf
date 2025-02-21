import { makeAutoObservable } from 'mobx'
import BasicComponentModel from '../ViewModel/BasicComponentModel'
import PageModel, { IComponentModel } from '../ViewModel/PageModel'
import ContainerModel from '../ViewModel/ContainerModel'
import { ICommonConfig } from '../Model/ICommonModel'
// import PropertyType from "../Constants/PropertyType";
import { Layout } from 'react-grid-layout'
import ProjectModel from '@/ViewModel/ProjectModel'
import { IPageMetadata } from '@/Model/IPageMetadata'
import RootStore from './root'
export default class DesignerStore {
  rootStore: RootStore
  id: string //当前工作区ID
  activeComponent: BasicComponentModel | ContainerModel | null
  projectModel: ProjectModel | null
  pageModel: PageModel | null
  pageID?: string
  gridIsDraggable = true
  inEditorView: boolean
  moveableComponent: BasicComponentModel | null

  constructor(rootStore: RootStore) {
    makeAutoObservable(this)
    this.id = ''
    this.activeComponent = null
    this.moveableComponent = null
    this.pageModel = new PageModel(null)
    this.inEditorView = false
    this.projectModel = new ProjectModel({
      id: '1',
      version: '0.0.1',
      type: 'Project'
    })
    this.projectModel.addPage(this.pageModel.pageMetadata)
    this.rootStore = rootStore
  }

  getActiveComponent() {
    return this.activeComponent
  }

  setPageData(data: IPageMetadata) {
    this.pageModel?.setData(data)
    this.projectModel?.addPage(data)
    if (this.activeComponent) {
      console.log('Setting new Active Componet:')
      const newActiveComponent = this.pageModel?.getComponentByID(
        this.activeComponent.componentInfo.id
      )
      if (newActiveComponent) {
        console.log('Setting new Active Componet: ', newActiveComponent)
        this.setActiveComponent(newActiveComponent)
      }
    }
  }

  clear() {
    this.activeComponent = null
    this.moveableComponent = null
  }

  changeComponentLayouts(allLayouts: Layout[], parent: PageModel | ContainerModel) {
    const components = parent instanceof PageModel ? parent.components : parent.children
    if (components == null) {
      return
    }
    for (const layout of allLayouts) {
      const component = components.find(
        (item: BasicComponentModel) => item.componentInfo.id === layout.i
      )
      if (component === undefined) {
        continue
      }
      component.changeLayout(layout)
    }
  }

  saveMetadata() {
    const data = this.pageModel?.getPageMetadata()
    console.log(data)
  }

  getPageData() {
    const data = this.pageModel?.getPageMetadata()
    return data
  }

  get pageData() {
    return this.getPageData()
  }

  setActiveComponent(com: IComponentModel | null | undefined) {
    this.activeComponent = com ?? null
  }

  deleteComponent(item: IComponentModel) {
    //必须由父组件来删除
    item.parent!.deleteComponent(item)
    this.activeComponent = null
  }

  get allComponents() {
    return this.pageModel?.components || []
  }

  setProperty(property: ICommonConfig): void {
    this.activeComponent?.setProperty(this.activeComponent.componentInfo.id, property)
  }

  setStyle(style: ICommonConfig): void {
    this.activeComponent?.setStyle(this.activeComponent.componentInfo.id, style)
  }

  changeGridDraggable(isDraggable = true) {
    this.gridIsDraggable = isDraggable
  }

  updateInView(inView: boolean) {
    this.inEditorView = inView
  }
}
