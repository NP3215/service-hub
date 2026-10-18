const express = require("express");
const cors = require("cors");

const workshopRoutes = require("./routes/workshopRoutes");
const authRoutes = require("../src/routes/authRoutes");
const bookingRoutes = require("../src/routes/bookingRoutes");
const userRoutes = require("../src/routes/userRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/workshops", workshopRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/bookings", bookingRoutes);
app.use("/api/user", userRoutes);

app.get("/", (req, res) => {
  res.json({
    message: "Workshop API is running"
  });
});

module.exports = app;