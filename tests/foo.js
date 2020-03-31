let bar = require('@rules_javascript/bar')
let baz = require('@rules_javascript/baz')

module.exports = function foo() {
  console.log('foo')

  bar()
  baz()
}
