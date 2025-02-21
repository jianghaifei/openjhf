import { Outlet } from 'react-router-dom'

function App() {
  return (
    <div className="flex w-full h-full">
      <Outlet></Outlet>
    </div>
  )
}

export default App
