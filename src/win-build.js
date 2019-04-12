const temp = require('art-template')
const fs = require('fs')
const path = require('path')
const os = require('os')
const exec = require('child_process').exec
const iconv = require('iconv-lite');
const chalk = require('chalk');

const binaryEncoding = 'binary'
const encoding = 'cp936'

const resolveRoot = function () {
  return path.resolve(__dirname, '../', ...arguments)
}

const ISCC = resolveRoot('lib/InnoSetup5/ISCC.exe')

async function build (config) {
  try {

    let source = fs.readFileSync(resolveRoot('config/template.iss')).toString()

    let str = temp.render(source, config, {escape: false, minimize: false})

    let buidISS = `${os.tmpdir()}\\innosetup-build\\build${Date.now()}.iss`

    if (!fs.existsSync(path.dirname(buidISS))) fs.mkdirSync(path.dirname(buidISS))
    fs.writeFileSync(buidISS, iconv.encode(str, 'gbk'))

    await new Promise((resolve, reject) => {
      const p = exec(`${ISCC} ${buidISS}`, {encoding: binaryEncoding})
      p.stdout.on('data', data => {
        console.log(iconv.decode(new Buffer(data, binaryEncoding), encoding))
      });
      p.stderr.on('data', error => {
        error = iconv.decode(new Buffer(error, binaryEncoding), encoding)
        console.log(chalk.red(error))
      });
      p.stdout.on('end', () => resolve())
      p.stdout.on('exit', () => resolve())
    })

    fs.unlinkSync(buidISS)
  } catch (e) {
    throw e
  }
}

module.exports = build
