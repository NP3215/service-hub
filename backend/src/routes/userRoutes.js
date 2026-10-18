const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/auth');

const { getProfile } = require('../controller/userController');

router.get("/profile", verifyToken, getProfile);

module.exports = router;
