import { Outlet } from "react-router-dom";
import exampleRoutes from "./example-routes";
import Takeaway from "./Takeaway";

export const Root = () => {
  return (
    <div className='bo-scaffold w-full h-full'>
      <Outlet></Outlet>
    </div>
  );
}


const routes = [
  {
    path: "/example",
    Component: Root,
    children: [
      ...exampleRoutes,
    ],
  },
  ...Takeaway
];

export default routes;
