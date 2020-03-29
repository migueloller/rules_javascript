let ListDataLib = require('./list_data_lib.js')

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
