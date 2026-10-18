-- ServiceHub database schema (TiDB / MySQL)
-- Disusun dari query di backend/src/controller/*.js

CREATE TABLE IF NOT EXISTS users (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  firebase_uid VARCHAR(128) NOT NULL UNIQUE,
  full_name    VARCHAR(100) NOT NULL,
  email        VARCHAR(150) NOT NULL,
  phone        VARCHAR(30),
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS workshops (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(150) NOT NULL,
  image_url VARCHAR(500),
  address   VARCHAR(255),
  latitude  DOUBLE NOT NULL,
  longitude DOUBLE NOT NULL,
  rating    DECIMAL(2,1) DEFAULT 0,
  is_open   TINYINT(1) DEFAULT 1,
  badge     VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS workshop_services (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  workshop_id  INT NOT NULL,
  service_name VARCHAR(100) NOT NULL,
  FOREIGN KEY (workshop_id) REFERENCES workshops(id)
);

CREATE TABLE IF NOT EXISTS bookings (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  firebase_uid VARCHAR(128) NOT NULL,
  workshop_id  INT NOT NULL,
  service_name VARCHAR(100) NOT NULL,
  booking_date DATE NOT NULL,
  booking_time TIME NOT NULL,
  notes        TEXT,
  status       VARCHAR(20) NOT NULL DEFAULT 'Pending',
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (workshop_id) REFERENCES workshops(id)
);

-- Data contoh supaya aplikasi tidak kosong saat pertama dijalankan
INSERT INTO workshops (name, image_url, address, latitude, longitude, rating, is_open, badge) VALUES
 ('Bengkel Maju Jaya',  'https://picsum.photos/seed/w1/600/400', 'Jl. Sudirman No. 10, Jakarta',   -6.2088, 106.8456, 4.8, 1, 'Terpopuler'),
 ('Auto Care Center',   'https://picsum.photos/seed/w2/600/400', 'Jl. Gatot Subroto No. 5, Jakarta', -6.2297, 106.8261, 4.6, 1, NULL),
 ('Speed Garage',       'https://picsum.photos/seed/w3/600/400', 'Jl. Kemang Raya No. 21, Jakarta',  -6.2615, 106.8106, 4.4, 0, 'Baru');

INSERT INTO workshop_services (workshop_id, service_name) VALUES
 (1,'Servis Berkala'),(1,'Ganti Oli'),(1,'Tune Up'),
 (2,'Ganti Oli'),(2,'Servis AC'),(2,'Balancing'),
 (3,'Servis Rem'),(3,'Ganti Ban'),(3,'Tune Up');
