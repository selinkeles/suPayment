// server packages
import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';

// rpc connection
import { connectToRPC } from "./connectToAlchemy";

// app settings
import { AppSettings } from "./appSettings";

// ORM client
import { PrismaClient, Prisma } from '@prisma/client';
import { Network } from 'alchemy-sdk';
const prisma = new PrismaClient()

// Express app  
const app = express()
app.use(express.json())

// WebSocket Server
const server = createServer(app);
const io = new Server(server);

// RPC Connection 
const { alchemy, wallet, contract } = connectToRPC(Network.MATIC_MUMBAI);


// HTTP Endpoints
app.get(`/`, (req, res) => {
  console.log("call: /");
  res.status(200).json({ message: `Hello World!` })
});

app.get(`/users`, async (req, res) => {
  console.log("call: /users");

  const all_users = await prisma.user.findMany();
  console.log("all_users: ", all_users);
  
  res.status(200).send( all_users );
});

app.get('/profile', async (req, res) => {
  console.log("call: /profile");
  const { user_address } = req.query;
  
  var picture_url, name;

  // dummy
  picture_url = "dummy";
  name = "dummy";

  res.json({
    "wallet_id": user_address,
    "picture_url": picture_url,
    "name": name
  });
});

app.post(`/link`, async (req, res) => {
  console.log("call: /link");
  const { userAddress, email } = req.body;
  const user = await prisma.user.create({
    data: {
      email: email,
      addr: userAddress,
    },
  })
  console.log(user);
  
  res.json(user);
});


app.post(`/subscribe`, async (req, res) => {
  console.log("call: /subscribe");
  const { userAddres } = req.body;
  
  await alchemy.notify.updateWebhook(
    AppSettings.webhook_id, {
    addAddresses: [userAddres]
  });

  res.json({ message: `your req.body: ${userAddres}` });
});


app.put('/edit', async (req,res) => {
  console.log("call: /edit");
  const { userAddres, image_url, name } = req.body;
  console.log( userAddres, image_url, name);
  res.status(200).end();
});



app.post("/webhook", (req, res) => {
  console.log("call: /webhook");
  console.log("webhook received!");

  const { webhookId, id, createdAt, type, event } = req.body;
  const { network, activity } = event;
  const { fromAddress, toAddress, value, asset} = activity[0];

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



// websocket event-listen
io.on('connection', (socket) => {
  console.log(`client connected`);

  socket.on("client-event", (d) => { console.log(d) });
  socket.emit('server-event', { tx_id: 'some value', otherProperty: 'other value' }); // This will emit the event to all connected sockets

  socket.on('disconnect', () => console.log('client disconneted'));

});


// start the server
server.listen(AppSettings.PORT, () => {
  console.log(`🚀 Server ready at: http://localhost:3000`);
});