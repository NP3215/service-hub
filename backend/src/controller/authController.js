const db = require("../config/tidb");

const registerUser =
async (req, res) => {

  try {

    const {
      firebase_uid,
      full_name,
      email,
      phone
    } = req.body;

    await db.execute(
      `
      INSERT INTO users
      (
        firebase_uid,
        full_name,
        email,
        phone
      )
      VALUES
      (?, ?, ?, ?)
      `,
      [
        firebase_uid,
        full_name,
        email,
        phone
      ]
    );

    res.status(201).json({
        success: true,
        message: "User Registered"
    });

  } catch (error) {
    console.log(error);
    res.status(500).json({
      message: error.message
    });
  }
};

const testConnection = async (req, res) => {
  try {
    const [rows] = await db.execute("SELECT 1");

    res.status(201).json({
      success: true,
      message: "Database connected",
      rows,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
};

const loginUser = async (req, res) => {
  try {
    const firebaseUid = req.user.uid;
    const [rows] = await db.execute(
      `SELECT id, firebase_uid, full_name, email, phone
      FROM users WHERE firebase_uid = ?
      `,
      [firebaseUid]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    return res.status(200).json({
      success: true,
      user: rows[0],
    });

  } catch (error) {

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

module.exports = { registerUser, testConnection, loginUser };