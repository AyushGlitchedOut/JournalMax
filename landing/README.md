# The landing Page for JournalMax

- This webpage and React App is for the github Pages of JournalMax. It is going to deployed on github pages from the docs folder in the root directory and this project is also configured to output the export into the docs directory which shoukd not be manually changed. Instead, any changes shoukd be made in this project which will reflect after export into the docs directory.
- The website has 3 pages: Homepage, Downloads Page and Documentation Page.
- For routing, React-Router and its HashRouter is used and vite is the build tool for the App.

# Running and building the Page

- The App uses vite and has all the commands predefined
- After installing, download all the node_modules:
  `npm i`
- Then, to run the devlopment server:
  `npm run dev`
- After that, when you have done the changes and want to commit them, first do:
  `npm run build`
  This command will first run prettier all over the directory, then build the production files in the docs directory from where Github can build the github pages

#### Credits

- [Downloads Icon](./public/download.png) - Radhe Icons, Flaticons
- [Free Icon](./public/free.png) - Pixel Perfect, Flaticons
- [Journal Icon](./public/journal.png)- Freepik, Flaticons
- [Lightning Icon](./public/lightning.png) - Freepik, Flaticons
- [Multimedia Icon](./public/multimedia.png) - Maxim Basinski Premium, Flaticons
- [Features Icon](./public/features.png) - Freepik, Flaticons
- [Lock Icon](./public/lock.png) - Dinosoft Labs, Flaticons
