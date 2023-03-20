import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';

import { connectToRPC } from "./connectToAlchemy";





// Express app  
const app = express()
app.use(express.json()) // ?

// WebSocket Server
const server = createServer(app);
const io = new Server(server);

// RPC Connection 
const {alchemy, wallet, contract } = connectToRPC();


// HTTP Endpoints
app.get(`/`, (req, res) => {
  res.json({ message: `Hello World!` })
})

app.post(`/subscribe`, async (req, res) => {
  const new_addr = JSON.parse(req.body);
  const WH_ID = "wh_k3obqec3wgywmmte";
  await alchemy.notify.updateWebhook(WH_ID, {
    addAddresses: [new_addr]
  });
  res.status(200).end();
})

app.post("/alchemyhook", (req, res) => {
  console.log("notification received!");
  //JSON.stringify(req.body)
  io.emit("notification", "hehe" ); // will be cached by client
  // res.status(200).end();
})

// WS Endpoints
io.on('connection', (socket) => {
  console.log('client connected');
  // socket.emit() to the cliet
  socket.emit('someevent', { someProperty: 'some value', otherProperty: 'other value' }); // This will emit the event to all connected sockets
  socket.on("ahoy", (d) => console.log(d));
  socket.emit("hel", {"ho": "bo"});
  socket.on('disconnect', () => console.log('client disconneted'));
});



// start the server
server.listen(3000, () => {
  console.log(`🚀 Server ready at: http://localhost:3000`);
});