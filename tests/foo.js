let bar = require('./bar')
let baz = require('./baz')

module.exports = function foo() {
  console.log('foo')

  bar()
  baz()
}
