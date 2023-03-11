import { Prisma, PrismaClient } from '@prisma/client'
import express, { json } from 'express'
import { connect } from './connect'
import { getAddress, parseEther } from 'ethers/lib/utils'

// Prisma settings
const prisma = new PrismaClient()

// Express settings
const app = express()

// Middleware
app.use(express.json())

app.get(`/`, async (req, res) => {
  res.json({ message: `Hello World!` })
})

// Endpoints
app.get(`/connect`, async (req, res) => {
  connect().then( async (result) => {
    const { alchemy, wallet, contract } = result
    const wallet_addr = wallet.address, contract_addr = contract.address
    let block_number = await alchemy.core.getBlockNumber()
    res.json({ block_number, wallet_addr, contract_addr })
  })
})

app.post(`/buy`, async (req, res) => {
  let { to, amount } = req.body
  to = getAddress(to)
  amount = parseEther(amount.toString())

  // connect to Alchemy
  connect().then( async (result) => {

    // get Alchemy, Wallet, and Contract
    const { alchemy, wallet, contract } = result
    
    // get current balance of wallet
    const balance = await contract.balanceOf(wallet.address)

    // mint amount of tokens to server
    const mint = await contract.mint(to, amount, { gasLimit: 1000000 })
    const mint_waited = await mint.wait()

    return res.json({ balance, mint_waited })
  })
})

const server = app.listen(3000, () =>
  console.log(`
🚀 Server ready at: http://localhost:3000
⭐️ See sample requests: http://pris.ly/e/ts/rest-express#3-using-the-rest-api`),
)
