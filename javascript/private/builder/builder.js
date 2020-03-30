const link = require('./link')

async function main({ argv: [_execPath, entryPoint, verb, ...args] }) {
  if (verb == null) {
    console.log(`usage: ${entryPoint} link options...`)

    return 2
  }

  let action

  switch (verb) {
    case 'link':
      action = link

      break

    default:
      console.log(`unknown action: ${verb}`)

      return 2
  }

  await action(args)

  return 0
}

main(process)
  .then(code => {
    process.exit(code)
  })
  .catch(error => {
    console.error(error.message)
    process.exit(1)
  })
