import {
  IconSmartphoneStroked,
  IconTaskMoneyStroked,
} from "@douyinfe/semi-icons";
import { Nav } from "@douyinfe/semi-ui";
import { NavItemProps, SubNavProps } from "@douyinfe/semi-ui/lib/es/navigation";
import { observer } from "mobx-react-lite";
import React, { ReactElement } from "react";
import { Link } from "react-router-dom";

const routerMap: Record<string | number, string> = {
  theme: "/designer",
  orderLayout: "/designer/order/layout",
  orderDesigner: "/designer/designer",
};

const Menu = observer(() => {
  return (
    <Nav
      className="w-full h-full shrink-0"
      style={{ width: 200, height: "100%", padding: 0, border: "none" }}
      bodyStyle={{ padding: 0, height: "100%" }}
      defaultOpenKeys={["theme", "order"]}
      renderWrapper={({
        itemElement,
        isSubNav,
        props,
      }: {
        itemElement: ReactElement;
        isInSubNav: boolean;
        isSubNav: boolean;
        props: NavItemProps | SubNavProps;
      }) => {
        if (isSubNav) {
          return <div>{itemElement}</div>;
        }
        return (
          <Link
            style={{ textDecoration: "none" }}
            to={routerMap[props.itemKey!]}
          >
            {itemElement}
          </Link>
        );
      }}
      items={[
        {
          itemKey: "theme",
          text: "主题",
          icon: <IconSmartphoneStroked />,
        },
        {
          itemKey: "order",
          text: "点单页",
          icon: <IconTaskMoneyStroked />,
          items: [
            {
              itemKey: "orderLayout",
              text: "布局",
            },
            {
              itemKey: "orderDesigner",
              text: "点单页",
            },
          ],
        },
      ]}
      onSelect={(data) => console.log("trigger onSelect: ", data)}
      onClick={(data) => console.log("trigger onClick: ", data)}
    />
  );
});

export default Menu;
