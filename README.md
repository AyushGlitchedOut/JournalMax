
<div align="center">
    <img src="assets/AppIcon.png" alt="AppIcon", height="250", width = "250">
</div>

## JournalMax!
- JournalMax is an Open-Source Android Journaling App ✍️🗒️
- The app is made using the flutter framework and the dart language 
- It's a personal project, by me, the Ayush Gupta as an opportunity to learn mobile devlopment 📱
- It has advanced features like storing Journal Entries along with multimedia like Location, Voice Recoding and Images, Exporting your data and many more.
- The app is completely open-source and doesn't have any backend, everything that is done is done locally on the device.

### Installation
- It is available as apk on [Github Pages](https://ayushglitchedout.github.io/JournalMax) of this project
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
    `flutter build apk --split-per-abi --split-debug-info=.build/debuginfo  --obfuscate`  
    and you will get the built apks somewhere in the build/app/outputs/apk/release folder. It would generate 3 apks, one for the newer arm64-v8a, armeabi-v7a for older devices, and x86_64 for x86 architecture (emulators). All of these are also present on the Github Pages for direct download. You dont need to specify anything in the `flutter run` command however, the system will automatically detect it. THe obfuscate and split-debug info are there to first obfuscate the released binary for security and split the debug info the reduce the apk size
- The apks that are released can/cannot have a signature, it would work none the less, it just depends if you want to use it for personal         purposes, create your own version, etc. The apks provided in Github Releases and hence, in Github Pages are signed by me. If you also want to sign the apks, dont follow the guides on internet as they mention a lot of stuff for google play store as well. Just do these two steps:
    - To first generate a keystore to sign the apk, use keytool:
        `keytool -genkey -v -keystore YourKeyStoreName.keystore -alias JournalMax -keyalg RSA -keysize 2048 -validity 10000`
    - This will generate a YourKeyStoreName.keystore file after asking you for a password and some information for creating a certificate. After that, use apksigner as follows:
        `apksigner sing -ks YourKeyStoreName.keystore --ks-key-alias JournalMax --out OutputName.apk /build/app/outputs/apk/app-abi-version-release.apk`
    - This will ask for the initially entered password and then generate a signed apk and an idsig file. You can now install the signed apk and just make sure to keep the keystore and its password safely and securely.
    - Note: Keytool comes with OpenJDk and apksigner comes with Android build-tools 
### Note
- This is just a simple project by me to learn programming and especially, mobile devlopment so don't expect too much from the app. It's just for learning things.
- Also, I have not opened contributions and am neither doing PRs, but if you have any ideas or suggestions, you can mail them here at ayushgupta.svma@gmail.com
- Thanks for viewing the project, a star would be appreciated
### License
- This project is licensed under the GNU General Public License v3.0. See the [LICENSE](./LICENSE) file for details
### Credits
- All the assets used in this project are made by me the Icon, the images, the themes. However, all the Icons used are either from MaterialIcons and a couple from CupertinoIcons, both provided along with the Flutter framework
