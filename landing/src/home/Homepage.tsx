import { useNavigate } from "react-router-dom";
import "./Homepage.css";
import AppIcon from "/AppIcon.webp";
import DownloadIcon from "/download.png";
import FreeIcon from "/free.png";
import JournalIcon from "/journal.png";
import LightningIcon from "/lightning.png";
import MultimediaIcon from "/multimedia.png";
import FeaturesIcon from "/features.png";
import LockIcon from "/lock.png";
import HeroImage from "/HomepageHero.webp";

export default function Homepage() {
  const navigator = useNavigate();

  return (
    <div className="homepage-main">
      {/* The part where we put the Hero image */}
      <div className="homepage-hero">
        <div className="homepage-hero-left"></div>
        <img src={HeroImage} alt="Hero Image" />
        <div className="homepage-hero-right"></div>
      </div>

      <div className="homepage-bottom-part">
        {/* The let side of bottom part for features text */}
        <div className="homepage-bottom-text-left">
          <ul>
            <li>
              <img src={FreeIcon} /> Completely free and Open Source
            </li>
            <li>
              <img src={LightningIcon} /> Easy to use and lightning fast
            </li>
            <li>
              <img src={LockIcon} />
              Everything done on device, ensuring Privacy
            </li>
          </ul>
        </div>

        {/* The center main part of the bottom part for the title and download button */}
        <div className="homepage-bottom-center">
          {/* Padding so the appicon doesnt cover up the elements */}
          <div className="homepage-bottom-center-iconpadding"></div>

          <img
            className="homepage-appicon"
            src={AppIcon}
            alt="AppIcon Not Found"
          />

          {/* The subtext */}
          <div className="homepage-bottom-center-appsubtext">
            The easy to use and free Journaling App for Android
          </div>

          {/* The download button */}
          <button
            onClick={() => navigator("/downloads")}
            className="homepage-bottom-center-downloadbutton"
          >
            <img src={DownloadIcon} />
            Download!
          </button>
        </div>
        {/* The right side of bottom part for features text */}
        <div className="homepage-bottom-text-right">
          <ul>
            <li>
              <img src={JournalIcon} />
              Store Your memories as journal Entries
            </li>
            <li>
              <img src={MultimediaIcon} />
              Store multimedia like Images, Voice Recordings and Location Data
              and Moods
            </li>
            <li>
              <img src={FeaturesIcon} />
              And many more features!
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
}
