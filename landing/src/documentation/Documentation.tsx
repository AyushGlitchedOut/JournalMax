import "./documentation.css";

export default function Documentation() {
  return (
    <div className="documentation-main">
      <h1>Documentation</h1>
      <ul>
        <li>
          <h3>The App</h3>
          <ul>
            <li>
              JournalMax is a free and Open-Source, Minimalist Journaling
              Application for Android devices
            </li>
            <li>
              It's a project made by Ayush Gupta, or{" "}
              <a href="https://github.com/AyushGlitchedOut">AyushGlitchedOut</a>
            </li>
            <li>
              The App doesn't have any server or backend and thus, is a
              completely offline app. (With a few extra features that aren't for
              core functionality that open websites, unrelated to app or any
              malicious intent i.e Github, GNU website and Google Maps)
            </li>
          </ul>
        </li>
        <li>
          <h3>Its Features Include:</h3>
          <ul>
            <li>Creating, Updating and Viewing Journal Entries</li>
            <li>
              Every Entry has a few elements: Title, Text Content, Date of
              creation, Location date, Attached Images and Voice Recording
            </li>
            <li>Light and Dark Themes</li>
            <li>Import and Export of data in local storage</li>
            <li>Searching for different Entries</li>
            <li>And many more...</li>
          </ul>
        </li>
        <li>
          <h3>Behind the Scenes (For technical purposes)</h3>
          <ul>
            <li>
              The app is made using the Flutter Framework. However, teh app
              currently is only configured, coded and built for android. Anyone
              interested can still fork and modify the app to work on IOS
              devices or as a matter of fact, any devices that flutter supports
            </li>
            <li>
              The App uses a SQLITE database for storing the text part of
              entries and the audio and image data are stored as files in the
              app's data storage. Recordings are stored in the .m4a extension
              with AAC encoding and images are stored as it is.
            </li>
            <li>
              Exporting creates a folder with the app name in the downloads
              directory and dumps all the stored data into the folder.
            </li>
          </ul>
        </li>
        <li>
          <h3>Credits for usage</h3>
          <ul>
            <li>
              Everything used in the JournalMax is Open-Source or some form of
              it.
            </li>
            <li>
              {" "}
              The material Icons used are licensed under the Apache License. The
              few Cupertino Icons are also under the MIT License
            </li>
            <li>
              Any other used in the actual project are made by me and all of the
              code (at the time of publishing of this page) is also written by
              me (with the exception of libraries used)
            </li>
            <li>
              <h4>Icons used in the Webpage:</h4>
              <ul>
                <li>Downloads Icon - Radhe Icons, Flaticons</li>
                <li>Free Icon - Pixel Perfect, Flaticons</li>
                <li>
                  Journal, Lightning and Features Icon - Freepik, Flaticons
                </li>
                <li>Multimedia Icon - Maxim Basinski Premium, Flaticons</li>
                <li>Lock Icon - Dinosoft labs, Flaticons</li>
                <li>Android Icon - Pictogrammer, Flaticons</li>
                <li>Build Icon - Juicy Fish, Flaticons</li>
              </ul>
            </li>
          </ul>
        </li>
        <li>
          <h3>Other information</h3>
          <ul>
            <li>
              If you want any info on builing the App or the source code, visit
              the README in the repo{" "}
            </li>
            <li>
              If you want to contact the author, email at{" "}
              <a href="/#/docs">ayushgupta.svma@gmail.com</a>
            </li>
          </ul>
        </li>
      </ul>
      <h1>Thanks For Using The App!</h1>
    </div>
  );
}
