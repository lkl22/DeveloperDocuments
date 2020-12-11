官网：[https://metamask.io/](https://metamask.io/)

浏览器插件项目源码：[https://github.com/MetaMask/metamask-extension](https://github.com/MetaMask/metamask-extension)

## Building locally

---

* Install [Node.js](https://nodejs.org/en/) version 8.11.3 and npm version 6.1.0
  * If you are using [nvm](https://github.com/creationix/nvm#installation) \(recommended\) running `nvm use`will automatically choose the right node version for you.
  * Select npm 6.1.0:`npm install -g npm@6.1.0`
* Install dependencies:`npm install`
* Install gulp globally with`npm install -g gulp-cli`.
* Build the project to the`./dist/`folder with`gulp build`.
* Optionally, to rebuild on file changes, run`gulp dev`.
* To package .zip files for distribution, run`gulp zip`, or run the full build & zip with`gulp dist`.

Uncompressed builds can be found in`/dist`, compressed builds can be found in`/builds`once they're built.

