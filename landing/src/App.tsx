import "./App.css";
import { HashRouter, Route, Routes } from "react-router-dom";
import Homepage from "./home/Homepage";
import Downloads from "./downloads/Downloads";
import Documentation from "./documentation/Documentation";
import Navbar from "./Components/Navbar";

function App() {
  return (
    <HashRouter>
      <Navbar />
      <div className="navbar-padding"></div>
      <Routes>
        <Route path="/" element={<Homepage />} />
        <Route path="/homepage" element={<Homepage />} />
        <Route path="/downloads" element={<Downloads />} />
        <Route path="/docs" element={<Documentation />} />
      </Routes>
    </HashRouter>
  );
}

export default App;
