import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';

import { connectToRPC } from "./connectToAlchemy";
import { WebhookType, Network } from 'alchemy-sdk';

import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient()


const PORT = 3000;

const webhook_id = "wh_1384qod48mj9dl0c";
const server_url = "https://6af0-159-20-68-5.eu.ngrok.io";

// Express app  
const app = express()
app.use(express.json())

// WebSocket Server
const server = createServer(app);
const io = new Server(server);

// RPC Connection 
const {alchemy, wallet, contract } = connectToRPC();


// HTTP Endpoints
app.get(`/`, (req, res) => {
  res.json({ message: `Hello World!` })
  console.log("hello world");
})

// selin
app.post(`/link`, async (req, res) => {
  console.log("oldu");
  console.log("body: ", req.body);

  const { wallet, email } = req.body;
  console.log("email: ", email);
  console.log("addr: ", wallet);

  // create a new user with email and addr=wallet
  //...

  
});

// deniz
app.post(`/subscribe`, async (req, res) => {
  const body = JSON.parse(req.body);
  console.log("body: ", body);

  const { address } = body;
  console.log("addr: ", address);
  
  await alchemy.notify.updateWebhook(
    webhook_id, {
    addAddresses: [address]
  });

  res.status(200).end();
});

// 
app.post("/alchemyhook", (req, res) => {
  console.log("notification received!");

  io.emit("notification", req.body); // will be cached by client
  res.status(200).end();
})


// WS Endpoints
io.on('connection', (socket) => {
  console.log(`client connected: ${socket.id}`);

  socket.on("subscribe", (d) => { d.addr  });
  socket.emit('tx', { tx_id: 'some value', otherProperty: 'other value' }); // This will emit the event to all connected sockets
  socket.emit('someevent', { someProperty: 'some value', otherProperty: 'other value' }); // This will emit the event to all connected sockets
  socket.on("ahoy", (d) => console.log(d));
  socket.emit("hel", {"ho": "bo"});
  socket.on('disconnect', () => console.log('client disconneted'));

});


// start the server
server.listen(PORT, () => {
  console.log(`🚀 Server ready at: http://localhost:3000`);
});