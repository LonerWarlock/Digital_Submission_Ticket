const express = require('express');
const mysql = require('mysql2');
const app = express();
const port = 3001;

// MySQL connection configuration
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'pict123',
  database: 'digi_sub_tick',
  insecureAuth: true,
});

// Connect to MySQL
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL database');
});

// Serve static HTML files from the 'public' directory
app.use(express.static('public'));

// Define routes

// Route for Student 1 dashboard
app.get('/student1', (req, res) => {
  const rollNo = 23246;

  // SQL query to retrieve data
  const query = `
  SELECT s_name, attendance, CG_mks, PA_mks, roll_no
  FROM student
  WHERE roll_no = 23246;  
  `;

  connection.query(query, [rollNo], (err, results) => {
    if (err) {
      console.error('Error fetching data:', err);
      res.status(500).send('Internal Server Error');
      return;
    }

    res.json(results);
  });
});


// Route for Student 2 dashboard
app.get('/student2', (req, res) => {
  // Fetch data from the 'marks' and 'student' tables
  const query = `
  SELECT s_name, attendance, CG_mks, PA_mks, roll_no
  FROM student
  WHERE roll_no = 23264;  
  `;

  connection.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching data:', err);
      res.status(500).send('Internal Server Error');
      return;
    }

    res.json(results);
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
