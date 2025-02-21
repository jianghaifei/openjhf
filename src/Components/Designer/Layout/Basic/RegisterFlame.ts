import {
  BottomButtons,
  MenuGroup,
  MenuList,
  OrderSidebar,
  SideButtons,
  TopMenu,
  OrderMenu,
  PayMethod,
  Payment,
  OrderListHeader,
  OrderListSidebar,
  OrderListContent
} from '@cyrilis/flame'

export const RegisterFlame = (it: unknown) => {
  OrderSidebar.Register(it)
  MenuGroup.Register(it)
  MenuList.Register(it)
  BottomButtons.Register(it)
  SideButtons.Register(it)
  TopMenu.Register(it)
  OrderMenu.Register(it)
  PayMethod.Register(it)
  Payment.Register(it)
  OrderListHeader.Register(it)
  OrderListSidebar.Register(it)
  OrderListContent.Register(it)
}
