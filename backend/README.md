# KINETIC Fashion Backend API

This is the backend API for the KINETIC Premium Fashion App, built with Node.js, Express, and PostgreSQL.

## Features

- **Authentication**: Secure user registration and login using JWT and bcrypt.
- **Product Management**: API for fetching products, categories, and product details with filtering and sorting.
- **Order Management**: Secure checkout process and order history.
- **Database**: Relational database schema designed for e-commerce.

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: PostgreSQL
- **Authentication**: JSON Web Tokens (JWT)
- **Logging**: Morgan
- **CORS**: Enabled for cross-origin requests

## Getting Started

### Prerequisites

- Node.js (v14+)
- PostgreSQL

### Installation

1. Clone the repository
2. Navigate to the backend directory: `cd backend`
3. Install dependencies: `npm install`
4. Create a `.env` file based on the provided configuration:
   ```env
   PORT=3000
   DATABASE_URL=postgres://user:password@localhost:5432/fashion_db
   JWT_SECRET=your_secret_key
   ```
5. Initialize the database using the script in `src/config/init_db.sql`.

### Running the Server

- Development mode: `npm run dev`
- Production mode: `npm start`

## API Endpoints

### Auth
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user info (Protected)

### Products
- `GET /api/products` - Get all products (Supports `category`, `search`, `sort` query params)
- `GET /api/products/categories` - Get all categories
- `GET /api/products/:id` - Get product details

### Orders
- `POST /api/orders` - Create a new order (Protected)
- `GET /api/orders` - Get user order history (Protected)
- `GET /api/orders/:id` - Get order details (Protected)

## License

MIT
