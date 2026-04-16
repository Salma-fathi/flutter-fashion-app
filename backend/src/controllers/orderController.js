const db = require('../config/db');

exports.createOrder = async (req, res) => {
  const { shippingAddressId, paymentMethodId, items } = req.body;
  const userId = req.user.id;

  const client = await db.pool.connect();
  try {
    await client.query('BEGIN');

    let totalAmount = 0;
    for (const item of items) {
      const product = await client.query('SELECT price FROM products WHERE id = $1', [item.productId]);
      if (product.rows.length === 0) throw new Error(`Product ${item.productId} not found`);
      totalAmount += product.rows[0].price * item.quantity;
    }

    const orderResult = await client.query(
      'INSERT INTO orders (user_id, total_amount, shipping_address_id, payment_method_id) VALUES ($1, $2, $3, $4) RETURNING id',
      [userId, totalAmount, shippingAddressId, paymentMethodId]
    );
    const orderId = orderResult.rows[0].id;

    for (const item of items) {
      const product = await client.query('SELECT price FROM products WHERE id = $1', [item.productId]);
      await client.query(
        'INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES ($1, $2, $3, $4)',
        [orderId, item.productId, item.quantity, product.rows[0].price]
      );
      // Update stock
      await client.query('UPDATE products SET stock = stock - $1 WHERE id = $2', [item.quantity, item.productId]);
    }

    await client.query('COMMIT');
    res.status(201).json({ message: 'Order created successfully', orderId });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error(err.message);
    res.status(500).send('Server error');
  } finally {
    client.release();
  }
};

exports.getOrders = async (req, res) => {
  try {
    const orders = await db.query('SELECT * FROM orders WHERE user_id = $1 ORDER BY created_at DESC', [req.user.id]);
    res.json(orders.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

exports.getOrderById = async (req, res) => {
  try {
    const order = await db.query('SELECT * FROM orders WHERE id = $1 AND user_id = $2', [req.params.id, req.user.id]);
    if (order.rows.length === 0) return res.status(404).json({ message: 'Order not found' });

    const items = await db.query(
      'SELECT oi.*, p.name, p.image_url FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = $1',
      [req.params.id]
    );

    res.json({ ...order.rows[0], items: items.rows });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};
