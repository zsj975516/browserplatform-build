/**
 * 生成升级配置文件 upgrade.json
 */
const path = require('path');
const YAML = require('yamljs');
const fs = require('fs');
const crypto = require('crypto');

const exec = require('child_process').exec

const resolvePath = function () {
  return path.resolve(process.env.INIT_CWD, ...arguments)
}

async function makeUpgrade(config) {
  const basePath = resolvePath('releases')
  try {
    let upgradeJson = {
      version: config.version,
      releaseDate: new Date(),
      file: {url: `赛威讯浏览器_${config.version}.exe`, size: 0, md5: ''}
    };

    let stat = fs.statSync(path.resolve(basePath, upgradeJson.file.url))

    upgradeJson.file.size = stat.size

    upgradeJson.file.md5 = await getMD5(path.resolve(basePath, upgradeJson.file.url))


    fs.writeFileSync(path.resolve(basePath, 'latest.yml'), YAML.stringify(upgradeJson, 4, 2), 'utf-8');
    if (config.build.openDirOnFinish) {
      exec(`start "" "${basePath}"`)
    }
  } catch (e) {
    throw e;
  }
}

function getMD5(filepath) {
  return new Promise((resolve, reject) => {
    let stream = fs.createReadStream(filepath)
    let fsHash = crypto.createHash('md5')
    stream.on('data', function (d) {
      fsHash.update(d)
    })
    stream.on('end', function () {
      let md5 = fsHash.digest('hex')
      resolve(md5)
    })
  })
}

module.exports = makeUpgrade;
