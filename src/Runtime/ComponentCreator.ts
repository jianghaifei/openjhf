import { IComponent } from '../Model/IComponent'
import BasicComponentModel from '../ViewModel/BasicComponentModel'
import PageModel from '../ViewModel/PageModel'
import ContainerModel from '../ViewModel/ContainerModel'

export const ComponentCreator = (item: IComponent, parent: PageModel | ContainerModel) => {
  if (item.children) {
    return new ContainerModel(item, parent)
  } else {
    return new BasicComponentModel(item, parent)
  }
}
