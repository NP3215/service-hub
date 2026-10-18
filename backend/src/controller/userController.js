const db = require('../config/tidb');

const getProfile = async (req, res) => {
  try {

    const firebase_uid = req.user.uid;

    const [rows] = await db.execute(
        `
        SELECT
          full_name,
          email,
          phone
        FROM users
        WHERE firebase_uid = ?
        `,
        [firebase_uid]
      );

    return res.status(200).json({
      success: true,
      data: rows[0],
    });

  } catch (error) {

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

module.exports = { getProfile };