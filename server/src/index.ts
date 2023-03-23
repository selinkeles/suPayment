import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';

import { connectToRPC } from "./connectToAlchemy";
import { WebhookType, Network } from 'alchemy-sdk';

import { PrismaClient, Prisma } from '@prisma/client';
const prisma = new PrismaClient()


const PORT = 3000;

const webhook_id = "wh_7r2u4rtc7lgwu2y1";
const server_url = "https://b959-159-20-68-5.eu.ngrok.io";

// Express app  
const app = express()
app.use(express.json())

// WebSocket Server
const server = createServer(app);
const io = new Server(server);

// RPC Connection 
const { alchemy, wallet, contract } = connectToRPC();


// HTTP Endpoints
app.get(`/`, (req, res) => {
  res.json({ message: `Hello World!` })
  console.log("hello world");
})

// selin oki
app.post(`/link`, async (req, res) => {
  console.log("oldu");
  console.log("body: ", req.body);

  const { wallet, email } = req.body;
  console.log("email: ", email);
  console.log("addr: ", wallet);

  const user = await prisma.user.create({
    data: {
      email: email,
      addr: wallet,
    },
  })
  console.log(user);
  
  res.json(user);
});

// deniz oki
app.post(`/subscribe`, async (req, res) => {
  console.log("oldu");
  console.log("body: ", req.body);

  const { address } = req.body;
  console.log("addr: ", address);
  
  await alchemy.notify.updateWebhook(
    webhook_id, {
    addAddresses: [address]
  });

  res.json({ message: `your req.body: ${address}` });
});

// for mail -> addr mapping oki
app.get(`/knownusers`, async (req, res) => {
  console.log("knownusers oldu");

  const all_users = await prisma.user.findMany();
  console.log("all_users: ", all_users);
  
  res.send( all_users );
});


// oki
app.post("/webhook", (req, res) => {
  console.log("notification received!");
  console.log("body: ", req.body);

  const { webhookId, id, createdAt, type, event } = req.body;
  console.log("webhookId: ", webhookId, "id: ", id, "createdAt: ", createdAt, "type: ", type, "event: ", event);

  const { network, activity } = event;
  console.log("network: ", network, "activity: ", activity);

  const {fromAddress, toAddress, value, asset} = activity[0];
  console.log("fromAddress: ", fromAddress, "toAddress: ", toAddress, "value: ", value, "asset: ", asset);

  const notif = {
    "toAddress": toAddress,
    "fromAddress": fromAddress,
    "value": value,
    "asset": asset,
  }
  // stringify the notification
  const notif_message = JSON.stringify(notif);

  // TODO: indexer - save tx to db for later retrieval
  io.emit("notification", notif_message); // will be cached by client
  res.status(200).end();
})



// oki
io.on('connection', (socket) => {
  console.log(`client connected`);

  socket.on("client-event", (d) => { console.log(d) });
  socket.emit('server-event', { tx_id: 'some value', otherProperty: 'other value' }); // This will emit the event to all connected sockets

  socket.on('disconnect', () => console.log('client disconneted'));

});


// start the server
server.listen(PORT, () => {
  console.log(`🚀 Server ready at: http://localhost:3000`);
});