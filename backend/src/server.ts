import express, { Response, Request } from "express";
import cors from "cors";
import morgan from "morgan";
import http from "http";
import { Server } from "socket.io";

const app: express.Application = express();

const address: string = "6060";

// Setting
app.set("port", process.env.PORT || address);

// Middlweres
app.use(morgan("dev"));
app.use(express.json());
// app.use(cors());

// Routes
app.get("/", (req: Request, res: Response) => {
  res.send("Server WORKING !!");
});

// Create http server
const server = http.createServer(app);

// Create socket.io instance
const io = new Server(server);

// Add event listeners
io.on("connection", (socket) => {
  console.log("New client connected");

  // Example event listener
  socket.on("message", (data) => {
    console.log(data);
    socket.broadcast.emit("message-recive", data);
    io.emit("example", data);
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected");
  });
});

// Server Starter
(() => {
  try {
    server.listen(app.get("port"));
    console.log(
      `Server is running on port http://localhost:${app.get("port")}`
    );
  } catch (error) {
    console.log(error);
  }
})();
