const express = require("express");

const router = express.Router();

const {
    getWorkshops,
    getWorkshopById,
    getNearbyWorkshops,
} = require("../controller/workshopController");

router.get("/", getWorkshops);

router.get("/nearby", getNearbyWorkshops);

router.get("/:id", getWorkshopById);

module.exports = router;