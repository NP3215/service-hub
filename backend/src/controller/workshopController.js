const db = require("../config/tidb");

const getWorkshops = async (req, res) => {
    try {

        const userLat = -6.200000;
        const userLng = 106.816666;

        const [rows] = await db.execute(`
            SELECT
                w.id,
                w.name,
                w.image_url,
                w.address,
                6371 * ACOS(
                COS(RADIANS(?))
                    * COS(RADIANS(w.latitude))
                    * COS(RADIANS(w.longitude) - RADIANS(?))
                    + SIN(RADIANS(?))
                    * SIN(RADIANS(w.latitude))
                ) AS distance,
                w.rating,
                w.is_open,
                w.badge,
                GROUP_CONCAT(ws.service_name) AS services
            FROM workshops w
            LEFT JOIN workshop_services ws
                ON w.id = ws.workshop_id
            GROUP BY w.id
            ORDER BY w.rating DESC
        `, [userLat, userLng, userLat]);

        const workshops = rows.map((workshop) => ({
            ...workshop,
            services: workshop.services
                ? workshop.services.split(",")
                : [],
        }));

        return res.status(200).json({
            success: true,
            data: workshops,
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};

const getWorkshopById = async (req, res) => {
    try {
        const { id } = req.params;
        const [workshop] = await db.execute(
            `
            SELECT *
            FROM workshops
            WHERE id = ?
            `,
            [id]
        );
        if (workshop.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Workshop not found",
            });
        }
        const [services] = await db.execute(
            `
            SELECT service_name
            FROM workshop_services
            WHERE workshop_id = ?
            `,
            [id]
        );
        return res.status(200).json({
            success: true,
            workshop: workshop[0],
            services,
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};

const getNearbyWorkshops = async (req, res) => {
    try {
        const { lat, lng, radius } = req.query;
        const [rows] = await db.execute(
            `
            SELECT *,
            (
                6371 * ACOS(
                COS(RADIANS(?))
                * COS(RADIANS(latitude))
                * COS(RADIANS(longitude) - RADIANS(?))
                + SIN(RADIANS(?))
                * SIN(RADIANS(latitude))
                )
            ) AS distance
            FROM workshops
            HAVING distance <= ?
            ORDER BY distance ASC
            `,
            [
                lat,
                lng,
                lat,
                radius,
            ]
        );

        return res.status(200).json({
            success: true,
            data: rows,
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};
module.exports = {
    getWorkshops,
    getWorkshopById,
    getNearbyWorkshops
};