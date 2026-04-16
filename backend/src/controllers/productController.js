const db = require('../config/db');

exports.getProducts = async (req, res) => {
  const { category, search, sort } = req.query;
  let queryText = 'SELECT p.*, c.name as category_name FROM products p JOIN categories c ON p.category_id = c.id WHERE 1=1';
  const params = [];

  if (category) {
    params.push(category);
    queryText += ` AND c.name = $${params.length}`;
  }

  if (search) {
    params.push(`%${search}%`);
    queryText += ` AND p.name ILIKE $${params.length}`;
  }

  if (sort) {
    if (sort === 'price_asc') queryText += ' ORDER BY p.price ASC';
    else if (sort === 'price_desc') queryText += ' ORDER BY p.price DESC';
    else if (sort === 'latest') queryText += ' ORDER BY p.created_at DESC';
  }

  try {
    const products = await db.query(queryText, params);
    res.json(products.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

exports.getProductById = async (req, res) => {
  try {
    const product = await db.query(
      'SELECT p.*, c.name as category_name FROM products p JOIN categories c ON p.category_id = c.id WHERE p.id = $1',
      [req.params.id]
    );
    if (product.rows.length === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json(product.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

exports.getCategories = async (req, res) => {
  try {
    const categories = await db.query('SELECT * FROM categories');
    res.json(categories.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};
