let ListDataLib = require('@rules_javascript/list_data_lib')

async function main() {
  let files = await ListDataLib.listData()

  files.forEach(file => {
    console.log(file)
  })
}

main().catch(error => {
  console.error(error)
  process.exit(1)
})
