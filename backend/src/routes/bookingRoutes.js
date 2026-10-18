const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/auth");

const {
  createBooking,
  getMyBookings,
  getAvailableSlots,
  cancelBooking,
  completeBooking
} = require("../controller/bookingController");

router.post("/", verifyToken, createBooking);

router.get("/my-bookings", verifyToken, getMyBookings);

router.get("/available-slots", getAvailableSlots);

router.patch("/:id/cancel", verifyToken, cancelBooking);

router.patch("/:id/complete", verifyToken, completeBooking);

module.exports = router;