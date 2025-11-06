import Header from "./components/Header";
import { Routes, Route } from "react-router-dom";
import Home from "./page/Home";
import Dashboard from "./page/Dashboard";

function App() {
  return (
    <>
      <Header />
      
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/dashboard" element={<Dashboard />} />
      </Routes>
    </>
  );
}

export default App;
