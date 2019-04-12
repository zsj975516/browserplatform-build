const nwBuild = require('./src/nw-build')
const winBuild = require('./src/win-build')
const publish = require('./src/publish.js')
const path = require('path')
const fs = require('fs')

const resolvePath = function () {
  return path.resolve(process.env.INIT_CWD, ...arguments)
}

let project_package = require(resolvePath('package.json'))

module.exports = async function () {
  if (!project_package.build) throw new Error('请在package.json中添加build')
  let nwBuilder = {
    files: ["dist/**/*"],
    platforms: ['win32'],
    version: '0.14.7',
    flavor: 'sdk',
    appName: 'BrowserPlatform',
    buildType: () => 'win-unpacked',
    zip: true,
    winIco: resolvePath("icon.ico"),
    buildDir: resolvePath("releases")
  }

  const newPackage = {
    ...project_package,
    main: 'index.html'
  }
  fs.writeFileSync(resolvePath('dist', 'package.json'), JSON.stringify(newPackage, null, 2))

  await nwBuild(nwBuilder)

  console.log('packing done\n');

  console.log('building...\n');

  await winBuild({
    AppExePath: resolvePath(`releases\\win-unpacked\\win32`),
    FilesPath: resolvePath(`releases\\win-unpacked\\win32`),
    AppExeName: `${nwBuilder.appName}.exe`,
    AppName: `赛威讯浏览器`,
    EnglishName: nwBuilder.appName,
    OutputDir: nwBuilder.buildDir,
    AppVersion: project_package.version,
    SetupIconFile: nwBuilder.winIco,
    AppId: "{{4206C95D-82B0-4006-92A2-6BA362F29CD3}",
    ...project_package.build.innosetup || {Files: [], Registry: []}
  })

  await publish(project_package)

  console.log('building done\n');
}
