// router/index.tsx
import { lazy, ReactNode, Suspense, useEffect } from "react";
import { RouteObject, useNavigate, useRoutes, Navigate } from "react-router-dom";
// import { RouteObject, useRoutes } from "react-router-dom";
import Loading from '../Basic/Loading'
import NotFound from '../Basic/NotFound'

interface Config {
  default?: {
    auth: boolean,
    navigate?: string
  }
}

type LazyFactory = Parameters<typeof lazy>[0];
type LazyReturn = ReturnType<typeof lazy>

const withCacheRefresh = (
  importResult: LazyFactory
): LazyFactory => () =>
  importResult().catch((err) => {
    if (window.confirm('Some component loaded failed, reload?')) {
      window.location.reload();
    }
    console.error(err)
    throw new Error('component load failed');
  });

const notFoundRoute: RouteObject[] = [
  {
    path: '*',
    Component: NotFound
  }
]

interface RouteInfo {
  path?: string,
  list?: string[],
  marked?: boolean
  element?: React.ReactNode
  children: RouteInfo[],
  isLayout?: boolean
}

export default function RRouter({extraRoutes = []}: { extraRoutes: RouteObject[]}) {
    const cache: Record<string, Config> = {}
    const context = require.context('../Pages/', true, /route\.ts$/, 'sync')
    context.keys().forEach((key: string) => (cache[key] = context<Config>(key)))
    
    const layoutCache: Record<string, boolean> = {}
    const layoutContext = require.context('../Pages/', true, /layout.tsx$/, 'lazy')
    layoutContext.keys().forEach((key: string) => (layoutCache[key] = true))

    const routesInfo: RouteObject[]  = Object.keys(cache).map((path) => {
      let element: ReactNode = routerLazyLoadingFn(lazy(withCacheRefresh(() => {
        const filePath = path.replace(/^(\.)/, '').replace(/route.ts$/, 'index.tsx')
        // eslint-disable-next-line @typescript-eslint/no-unsafe-return
        return import(`../Pages${filePath}`)
      })))
      const module = cache[path]
      if (module && module.default?.navigate) {
        element = <Navigate to={module.default?.navigate} />
      }
      const routerPath = path.replace(/^(\.)/, '').replace(/\/route.ts$/, '').split('/').map(s => {
        if (/\[[a-zA-Z0-9]+\]/.test(s)) {
          return s.replace(/\[([a-zA-Z0-9]+)\]/g, ':$1')
        } else {
          return s
        }
      }).join('/')
      return {
        path: routerPath, element
      } as RouteObject
    })

    const layoutList: RouteInfo[] = Object.keys(layoutCache).map((path) => {
      const element: ReactNode = routerLazyLoadingFn(lazy(withCacheRefresh(() => {
        const filePath = path.replace(/^(\.)/, '')
        // eslint-disable-next-line @typescript-eslint/no-unsafe-return
        return import(`../Pages${filePath}`)
      })))
      const routePath = path.replace(/^(\.)\//, '').replace(/layout.tsx$/, '').split('/').filter(s => s.length > 0).map(s => {
        if (/\[[a-zA-Z0-9]+\]/.test(s)) {
          return s.replace(/\[([a-zA-Z0-9]+)\]/g, ':$1')
        } else {
          return s
        }
      }).join('/')
      return {
        path: routePath,
        element,
        list: routePath.split('/'),
        children: [],
        marked: false,
        isLayout: true
      } as RouteInfo
    })

    const layoutRoute: RouteObject[] = []

    layoutList.map(layout => {
      let index = -1
      let near = -1
      layoutList.map((item, idx) => {
        if (item === layout) return
        if (layout.list?.slice(0, item.list?.length).join('/') === item.list?.join('/')) {
          if (index < 0 || near > (item.list?.length || 0)) {
            index = idx
            near = item.list?.length || 0
          }
        }
      })

      if (index >= 0) {
        const parent = layoutList[index]
        layout.path = layout.list?.slice(near - 1).join('/')
        parent.children?.push(layout)
        if (!parent.marked) {
          parent.marked = true
          layoutRoute.push(parent)
        }
      } else {
        const notNested = layout
        if (!notNested.marked) {
          notNested.marked = true
          layoutRoute.push(notNested)
        }
      }
    })

    const stepOver = (list: RouteInfo[], path: string) => {
      let target: RouteInfo | undefined
      let resPath = path
      const pathList = path.split('/').filter(item => item)
      list.map(item => {
        const layoutPathList = item.path?.split('/') || []
        console.log(layoutPathList.join('/'), pathList.slice(0, layoutPathList.length).join('/'))
        if (layoutPathList.join('') === '' || layoutPathList.join('/') === pathList.slice(0, layoutPathList.length).join('/')) {
          target = item
          const result = stepOver(item.children || [], path.slice(layoutPathList.length))
          if (result && result.target) {
            resPath = result.path
            target = result.target
          }
        }
      })
      if (target) {
        return { target, path: resPath}
      }
    }

    const removeMarks: number[] = []
    routesInfo.map((route, idx) => {
      const result = stepOver(layoutRoute as RouteInfo[], route.path || '')
      if (result) {
        result.target.children?.push({
          children: [],
          element: route.element,
          path: result.path
        })
        removeMarks.push(idx)
      }
    })
    removeMarks.reverse().forEach((idx: number) => {
      routesInfo.splice(idx, 1)
    })

    const stepOverLayout = (list: RouteInfo[]) => {
      list.map(item => {
        if (item.isLayout) {
          delete item.path
        }
        if (item.children) {
          stepOverLayout(item.children)
        }
      })
    }
    stepOverLayout(layoutRoute as RouteInfo[])


    const routes = useRoutes(extraRoutes.concat(layoutRoute).concat(routesInfo).concat(notFoundRoute))
    return routes
}

export const AuthComponent = ({ children }: { children: JSX.Element}) => {
    const navigation = useNavigate()
    if (localStorage.getItem('token')) {
      return children
    } else {
      // eslint-disable-next-line react-hooks/rules-of-hooks
      useEffect(() => {
        navigation('/login', undefined)
      })
    }
}

const routerLazyLoadingFn = (Element: LazyReturn) => <Suspense fallback={<Loading></Loading>}>
    <Element />
</Suspense>
