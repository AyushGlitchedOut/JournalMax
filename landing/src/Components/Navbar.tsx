import { useLocation, useNavigate } from "react-router-dom";
import "./Navbar.css";

export default function Navbar() {
  const activeTab = useLocation().pathname;
  console.log(activeTab);
  const navigator = useNavigate();

  const isHomepageActive: boolean = activeTab == "/homepage";
  const isDownloadsActive: boolean = activeTab == "/downloads";
  const isDocsActive: boolean = activeTab == "/docs";

  function openPage(path: string): void {
    navigator(path);
  }

  //the main navbar
  return (
    <div className="navbar-box">
      {/* the starting part of the navbar */}
      <div className="navbar-initial">
        <button
          onClick={() => openPage("/homepage")}
          style={
            isHomepageActive ? { backgroundColor: "rgba(128,128,128,0.5)" } : {}
          }
        >
          Home
        </button>
        <button
          onClick={() => openPage("/downloads")}
          style={
            isDownloadsActive
              ? { backgroundColor: "rgba(128,128,128,0.5)" }
              : {}
          }
        >
          Download
        </button>
      </div>

      {/* the Main title */}
      <div className="navbar-title">JournalMax</div>

      {/* THe end part */}
      <div className="navbar-end">
        <button
          onClick={() => openPage("/docs")}
          style={
            isDocsActive ? { backgroundColor: "rgba(128,128,128,0.5)" } : {}
          }
        >
          Documentation
        </button>
        <button>Review</button>
        <button
          onClick={() =>
            window.open("https://github.com/AyushGlitchedOut/JournalMax")
          }
        >
          Source
        </button>
      </div>
    </div>
  );
}
