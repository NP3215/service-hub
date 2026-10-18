const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/auth");

const {
  registerUser,
  testConnection,
  loginUser,
} = require("../controller/authController");

router.post("/register", registerUser);
router.get("/test", testConnection);
router.get("/login", verifyToken, loginUser);

module.exports = router;
