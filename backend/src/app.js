const express = require("express");
const cors = require("cors");

const workshopRoutes = require("./routes/workshopRoutes");
const authRoutes = require("../src/routes/authRoutes");
const bookingRoutes = require("../src/routes/bookingRoutes");
const userRoutes = require("../src/routes/userRoutes");

const app = express();

// ALLOWED_ORIGINS (opsional, pisahkan dengan koma), contoh:
//   https://servicehub3215.web.app,https://servicehub3215.firebaseapp.com
// Jika tidak diisi (mis. saat development lokal), semua origin diizinkan.
const allowedOrigins = process.env.ALLOWED_ORIGINS
  ? process.env.ALLOWED_ORIGINS.split(",").map((o) => o.trim()).filter(Boolean)
  : null;

app.use(cors(allowedOrigins ? { origin: allowedOrigins } : undefined));
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