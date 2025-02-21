import { makeAutoObservable } from 'mobx'
import { IPageMetadata } from '../Model/IPageMetadata'
import BasicComponentModel from './BasicComponentModel'
import ContainerModel from './ContainerModel'
import { IPageConfig, IProjectMetadata } from '@/Model/IProjectMetadata'
import ComponentHelper from '@/Utils/ComponentHelper'
import { IComponent } from '@/Model/IComponent'

export type IComponentModel = BasicComponentModel | ContainerModel

export default class ProjectModel {
  private pages: IPageMetadata[] = []
  private data: IProjectMetadata = {
    id: '',
    type: 'Project', //page | container
    version: '0.0.1',
    title: '',
    description: ''
  }

  constructor(data: IProjectMetadata) {
    makeAutoObservable(this)
    if (data) {
      this.data = data
    }
  }

  setData(data: IProjectMetadata) {
    this.data = data
  }

  setPage(id: string, page: IPageMetadata) {
    let pageIdx
    if (id) {
      pageIdx = this.pages.findIndex((page) => {
        return page.id === id
      })
    } else {
      return
    }
    if (pageIdx && pageIdx >= 0) {
      this.pages[pageIdx] = page
    }
  }

  deletePage(id: string) {
    if (id) {
      const pageIdx = this.pages.findIndex((page) => {
        return page.id === id
      })
      this.pages.splice(pageIdx, 1)
    }
  }

  getProjectSchema(): IProjectMetadata {
    const pages: IPageConfig[] = this.pages.map((page: IPageMetadata) => {
      return {
        id: page.id,
        type: 'Page',
        title: page.title || page.props.title,
        path: page.props.route
      }
    })
    const componentsTree = this.pages.map((page) => {
      return {
        id: page.id,
        type: page.type,
        name: page.title || page.props.title,
        children: page.componentsTree,
        props: page.props,
        layout: page.layout,
        style: page.style
      } as IComponent
    })
    return {
      id: this.data.id,
      type: 'Project', //page | container
      title: this.data.title,
      version: this.data.version,
      description: this.data.description,
      template: this.data.template,
      config: this.data.config,
      style: this.data.config,
      pages,
      componentsTree,
      componentsMap: ComponentHelper.getComponentMap()
    }
  }

  getPageByID(id: string): IPageMetadata | undefined {
    const pageIdx = this.pages.findIndex((page) => {
      return page.id === id
    })
    if (pageIdx >= 0) {
      const page = this.pages[pageIdx]
      return page
    }
  }

  updatePageByID(id: string, page: IPageMetadata) {
    const pageIdx = this.pages.findIndex((page) => {
      return page.id === id
    })
    if (pageIdx >= 0) {
      this.pages[pageIdx] = page
    }
  }

  addPage(page: IPageMetadata | null) {
    if (!page) return
    const id = page.id
    if (
      this.pages.findIndex((p) => {
        return p.id === id
      }) >= 0
    )
      return
    this.pages.push(page)
  }

  removePage(id: string) {
    const pageIdx = this.pages.findIndex((page) => {
      return page.id === id
    })
    if (pageIdx >= 0) {
      this.pages.splice(pageIdx, 1)
    }
  }
}
