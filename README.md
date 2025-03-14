
<div align="center">
    <img src="assets/AppIcon.png" alt="AppIcon", height="250", width = "250">
</div>

## JournalMax!
- JournalMax is an Open-Source Android Journaling App ✍️🗒️
- The app is made using the flutter framework and the dart language 
- It's a personal project, by me, the Ayush Gupta as an opportunity to learn mobile devlopment 📱
- It has advanced features like storing Journal Entries along with multimedia like Location, Voice Recoding and Images, Exporting your data and many more are in Progress!
- The app is completely open-source and doesn't have any backend, everything that is done is done locally on the device. (Conditions might apply for the future implementation of Google Drive Sync) 

### Installation
- The app isn't ready to install or use currently as it's still in devlopment
- When the app will be ready, it will be available as apk on [Github Pages](https://ayushglitchedout.github.io/journalmax) of this project
- If you want, you can build the current commit but there's no guarantee if it would properly work or even build in the first place

## Building the App
- This project uses plugins and libraries that require Java version 17 so before builing, make sure you are using OpenJDK 17. If you are using an older/later version, you can do(for debian and ubuntu/ its relatives):
    `sudo apt install openjdk-17-jdk openjdk-17-jre`
    and then to see the available versions:
    `sudo update-alternatives --list java`
    after that:
    `sudo update-alternatives --config java` 
    and select jdk-17 if it's not already selected. After that, you can finally build the project

- The app is made using flutter so to run it, 
   `flutter run`
   However, note that while flutter is an cross-platform framework, the app is specially only made and tested for android and many things are hard-coded for android systems. You can fork the repository and make an ios version if you want but I don't have any intention of making the project ios-suporting anytime soon.
- To build the release version apk, just do
    `flutter build apk`
    and you will get the built apk somewhere in the build/app/outputs/apk folder

### Note
- This is just a simple project and that too in-progress by me to learn programming and especially, mobile devlopment so don't expect too much from the app. It's just for learning things.
- Also, I have not opened contributions and am neither doing PRs, but if you have any ideas or suggestions, you can mail them here at ayushgupta.svma@gmail.com
- Thanks for viewing the project, a star would be appreciated
### License
- This project is licensed under the GNU General Public License v3.0. See the [LICENSE](./LICENSE) file for details
