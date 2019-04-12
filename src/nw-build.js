const NwBuilder = require('nw-builder')

/**
 * 开始构建nw
 */
async function build (config = {}) {
  return new Promise(function (resolve, reject) {
    let nw = new NwBuilder(config)
    nw.on('log', console.log)
    nw.build(function (err, data) {
      if (err) throw err
      resolve()
    })
  })
}

module.exports = build
