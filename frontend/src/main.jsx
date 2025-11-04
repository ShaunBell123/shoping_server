import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'


function MainContent() {
  return (
    <div className="MainContent">
      <h1>react is great!</h1>
    </div>
  )
}





createRoot(document.getElementById('root')).render(
  <StrictMode>
    <MainContent/>
  </StrictMode>
)
