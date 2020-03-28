let qux = require('./qux')

module.exports = function bar() {
  qux()

  console.log('baz')
}
