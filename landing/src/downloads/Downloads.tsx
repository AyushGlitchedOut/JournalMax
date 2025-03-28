import "./Downloads.css";
import AndroidIcon from "/android.png";
import BuildIcon from "/build.png";
import { useRef } from "react";

export default function Downloads() {
  const dialog = useRef<HTMLDialogElement>(null);
  return (
    <div className="downloads-main">
      <dialog ref={dialog}>
        <p>
          Hey, You are downloading the App made for an older versions of phones
          and processors. If your phone was released after 2019, you should
          first try the second option. Otherwise, you can continue for legacy
          devices.
        </p>
        <div>
          <button
            onClick={() => {
              dialog.current?.close();
            }}
          >
            Cancel
          </button>
          <button
            onClick={() => {
              const link = document.createElement("a");
              link.href =
                "https://github.com/AyushGlitchedOut/JournalMax/releases/download/release/release-v7a.apk";
              link.download = "release-v7a.apk";
              document.body.appendChild(link);
              link.click();
              document.body.removeChild(link);
            }}
          >
            Continue
          </button>
        </div>
      </dialog>

      <div className="downloads-left">
        <img
          src={AndroidIcon}
          alt="android"
          className="downloads-left-android-icon"
        />
        <p className="downloads-left-title">Download Apk - Version : 1.0.0</p>
        <DownloadButton
          text="Download Apk for older devices"
          abi="For armeabi-v7a"
          onClick={() => {
            dialog.current?.showModal();
          }}
        />
        <DownloadButton
          text="Download Apk for newer devices"
          abi="For armabi-v8a"
          onClick={() => {}}
          downloadURL="https://github.com/AyushGlitchedOut/JournalMax/releases/download/release/release-v8a.apk"
        />
        <DownloadButton
          text="Download Apk for emulators/desktop"
          abi="For x86_64"
          onClick={() => {}}
          downloadURL="https://github.com/AyushGlitchedOut/JournalMax/releases/download/release/release-x86_64.apk"
        />
      </div>
      <hr className="downloads-divider" />
      <div className="downloads-right">
        <img
          src={BuildIcon}
          alt="build"
          className="downloads-right-build-icon"
        />
        <div className="downloads-right-title">Get the Source Code</div>
        <p>
          Github Repository:{" "}
          <a href="https://github.com/AyushGlitchedOut/JournalMax">
            JournalMax
          </a>
        </p>
        <p>
          Clone using git:{" "}
          <code>git clone https://github.com/AyushGlitchedOut/JournalMax</code>
        </p>
        <a
          href="https://github.com/AyushGlitchedOut/JournalMax/archive/refs/tags/release.zip"
          download={true}
        >
          <p>Download Zip Archive</p>
        </a>
        <a
          href="https://github.com/AyushGlitchedOut/JournalMax/archive/refs/tags/release.tar.gz"
          download={true}
        >
          <p>Download Tarball</p>
        </a>
        <div>
          Note: The instructions on Building are in the README.md file in the
          source code
        </div>
      </div>
    </div>
  );
}

interface ButtonProps {
  text: string;
  abi: string;
  onClick: Function;
  downloadURL?: string;
}

function DownloadButton(props: ButtonProps) {
  return (
    <a
      className="downloads-button"
      onClick={() => props.onClick()}
      download={true}
      href={props.downloadURL}
    >
      <p className="downloads-button-title">{props.text}</p>
      <p className="downloads-button-abi">{props.abi}</p>
    </a>
  );
}
