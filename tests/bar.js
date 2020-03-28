let baz = require('./baz.js')

module.exports = function bar() {
  console.log('bar')

  baz()
}
