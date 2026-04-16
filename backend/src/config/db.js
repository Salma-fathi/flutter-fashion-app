const { Pool } = require('pg');
require('dotenv').config();

// Since PostgreSQL is not available in this environment, 
// we will use a mock database layer or assume it will be available in production.
// For the sake of this task, I will write the code as if PG is available.

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool
};
