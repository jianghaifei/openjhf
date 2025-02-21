import { BrowserRouter } from 'react-router-dom'
import ReactDOM from 'react-dom/client'
import './index.css'
import Router from './Router/index.tsx'
import StoreContext from './Store/storeContext.ts'
import RootStore from './Store/root.ts'

const root = ReactDOM.createRoot(document.getElementById('root')!)
root.render(
  <StoreContext.Provider value={new RootStore()}>
    <BrowserRouter>
      <Router></Router>
    </BrowserRouter>
  </StoreContext.Provider>
)
