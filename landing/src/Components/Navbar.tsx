import { useLocation, useNavigate } from "react-router-dom";
import "./Navbar.css";
import DownloadIcon from "/download.png";
import { useEffect, useState } from "react";

export default function Navbar() {
  const activeTab = useLocation().pathname;
  const navigator = useNavigate();

  const isHomepageActive: boolean =
    activeTab == "/homepage" || activeTab == "/";
  const isDownloadsActive: boolean = activeTab == "/downloads";
  const isDocsActive: boolean = activeTab == "/docs";

  const [isOnMobile, setIsOnMobile] = useState(false);

  useEffect(() => {
    const onMobile = () => setIsOnMobile(window.innerWidth <= 768);

    onMobile();
    window.addEventListener("resize", onMobile);

    return () => window.removeEventListener("resize", onMobile);
  }, []);

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
          {isOnMobile ? (
            <img
              src={DownloadIcon}
              style={{ aspectRatio: 1, width: "60%", marginTop: "10%" }}
            />
          ) : (
            "Downloads"
          )}
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
          {isOnMobile ? "Docs" : "Documentation"}
        </button>
        <button
          onClick={() =>
            window.open(
              "https://docs.google.com/forms/d/e/1FAIpQLSfHbqpRPvJceew_Y4xvtTO38NP1KiyrQntQ5o3IXqUKvct1Pw/viewform?usp=dialog",
            )
          }
        >
          Review
        </button>
        {isOnMobile ? null : (
          <button
            onClick={() =>
              window.open("https://github.com/AyushGlitchedOut/JournalMax")
            }
          >
            Source
          </button>
        )}
      </div>
    </div>
  );
}
