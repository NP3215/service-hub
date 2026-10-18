const db = require("../config/tidb");

const createBooking = async (req, res) => {
  try {

    const firebase_uid = req.user.uid;

    const {
      workshop_id,
      service_name,
      booking_date,
      booking_time,
      notes,
    } = req.body;

    const [existing] = await db.execute(
      `
      SELECT id
      FROM bookings
      WHERE workshop_id = ?
      AND booking_date = ?
      AND booking_time = ?
      AND status != 'Cancelled'
      `,
      [
        workshop_id,
        booking_date,
        booking_time,
      ]
    );

    if (existing.length > 0) {
      return res.status(400).json({
        success: false,
        message: "Time slot already booked",
      });
    }

    const [result] = await db.execute(
      `
      INSERT INTO bookings
      (
        firebase_uid,
        workshop_id,
        service_name,
        booking_date,
        booking_time,
        notes
      )
      VALUES (?, ?, ?, ?, ?, ?)
      `,
      [
        firebase_uid,
        workshop_id,
        service_name,
        booking_date,
        booking_time,
        notes,
      ]
    );

    // Demo Auto Confirmation
    setTimeout(async () => {
      try {

        await db.execute(
          `
          UPDATE bookings
          SET status = 'Confirmed'
          WHERE id = ?
          AND status = 'Pending'
          `,
          [result.insertId]
        );

        console.log(
          `Booking ${result.insertId} automatically confirmed`
        );

      } catch (error) {

        console.error(
          "Auto confirm error:",
          error.message
        );

      }
    }, 5000);

    return res.status(201).json({
      success: true,
      bookingId: result.insertId,
      message: "Booking created successfully",
    });

  } catch (error) {

    console.error(error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};


const getAvailableSlots = async (req, res) => {
  try {

    const {
      workshopId,
      date,
    } = req.query;

    const allSlots = [
      "08:00",
      "09:30",
      "11:00",
      "13:30",
      "15:00",
      "16:30",
    ];

    const [bookings] =
      await db.execute(
        `
        SELECT booking_time
        FROM bookings
        WHERE workshop_id = ?
        AND booking_date = ?
        AND status != 'Cancelled'
        `,
        [workshopId, date]
      );

    const booked =
      bookings.map(
        (b) =>
          b.booking_time
            .toString()
            .substring(0, 5)
      );

    const available =
      allSlots.filter(
        (slot) =>
          !booked.includes(slot)
      );

    return res.status(200).json({
      success: true,
      slots: available,
    });

  } catch (error) {

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

const getMyBookings = async (req, res) => {
  try {

    const firebaseUid = req.user.uid;

    const [rows] =
      await db.execute(
        `
        SELECT
          b.id,
          b.service_name,
          b.booking_date,
          b.booking_time,
          b.status,

          w.name,
          w.image_url

        FROM bookings b

        JOIN workshops w
        ON b.workshop_id = w.id

        WHERE b.firebase_uid = ?

        ORDER BY b.booking_date DESC
        `,
        [firebaseUid]
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

const cancelBooking = async (req, res) => {
  try {

    const { id } = req.params;

    await db.execute(
      `
      UPDATE bookings
      SET status = 'Cancelled'
      WHERE id = ?
      `,
      [id]
    );

    return res.status(200).json({
      success: true,
    });

  } catch (error) {

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

const completeBooking = async (
  req,
  res
) => {

  const { id } = req.params;

  await db.execute(
    `
    UPDATE bookings
    SET status = 'Completed'
    WHERE id = ?
    `,
    [id]
  );

  return res.json({
    success: true,
  });
};

module.exports = {
  createBooking,
  getMyBookings,
  getAvailableSlots,
  cancelBooking,
  completeBooking
};