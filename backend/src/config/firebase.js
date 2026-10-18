const admin = require("firebase-admin");

// Production (Render): kunci Firebase dibaca dari environment variable.
//   FIREBASE_SERVICE_ACCOUNT_BASE64 = isi ServiceAccountKey.json yang di-encode base64
//   FIREBASE_SERVICE_ACCOUNT        = isi ServiceAccountKey.json apa adanya (JSON)
// Lokal: jika tidak ada env di atas, dipakai file ServiceAccountKey.json seperti biasa.
function loadServiceAccount() {
  if (process.env.FIREBASE_SERVICE_ACCOUNT_BASE64) {
    return JSON.parse(
      Buffer.from(process.env.FIREBASE_SERVICE_ACCOUNT_BASE64, "base64").toString("utf8")
    );
  }
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    return JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  }
  return require("../../ServiceAccountKey.json");
}

admin.initializeApp({
  credential: admin.credential.cert(loadServiceAccount()),
});

module.exports = admin;
