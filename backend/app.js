const express = require('express');
const mysql = require('mysql2');
const dotenv = require('dotenv');
const cors = require('cors'); // เพิ่ม cors

dotenv.config();  // โหลดตัวแปรจากไฟล์ .env

const app = express();
const port = process.env.PORT || 3001;

// MySQL database connection
const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the UPS monitoring database.');
});

// ใช้ CORS middleware
app.use(cors()); 

// Route สำหรับหน้าแรก
app.get('/', (req, res) => {
  res.send('Welcome to the UPS Monitoring System!');
});

// Route สำหรับดึงข้อมูล UPS
app.get('/ups', (req, res) => {
  const query = 'SELECT * FROM ups_data';
  
  connection.query(query, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      res.status(500).json({ error: 'Database query error' });
      return;
    }
    res.status(200).json(results);  // เพิ่ม status code 200
  });
});

// เริ่มการทำงานของ server
app.listen(port, '0.0.0.0', () => {
  console.log(`UPS monitoring app listening at http://0.0.0.0:${port}`);
});
