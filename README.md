# 🛍️ ShopMe

**ShopMe** is a modern e-commerce platform built with **Ruby on Rails**, offering a smooth shopping experience and efficient admin tools. It supports user authentication, admin management, interactive UI using **Hotwire**, and clean styling via **Tailwind CSS**.

---

## ✨ Features

### 🧑‍💻 User-Facing

- Secure Devise authentication for users
- Browse products and categories
- Product detail page with image carousel
- Size and quantity selection
- Add to cart and checkout (Stripe integration)
- View order history and download **receipts**
- Submit and view testimonials

### 🛠️ Admin Panel

- Separate Devise authentication for admins
- Dashboard under `/admin`
- Manage:
  - Products (with nested stock management)
  - Categories
  - Orders
  - Testimonials (approval flow)

---

## 🧰 Tech Stack

| Layer           | Tooling                       |
| --------------- | ----------------------------- |
| **Backend**     | Ruby on Rails 8               |
| **Auth**        | Devise (Users & Admins)       |
| **Frontend**    | Hotwire (Turbo + Stimulus.js) |
| **JS Bundling** | Importmaps (no Webpack)       |
| **Styling**     | Tailwind CSS                  |
| **Uploads**     | Active Storage                |
| **Payments**    | Stripe                        |
| **Deployment**  | Render                        |

---

## ⚙️ Getting Started

### Prerequisites

- Ruby 3.x
- Rails 8.x
- PostgreSQL or SQLite (dev)
- Node.js & Yarn (optional)
- ImageMagick (for image variants)
- Webrick

### Setup Instructions

````bash
# Clone and enter the project
git clone https://github.com/your-username/shopme.git
cd shopme

# Install dependencies
bundle install

# Set up the database
rails db:create db:migrate db:seed

# Start the development server
bin/dev

### Environment Variables
```env
STRIPE_PUBLIC_KEY=your_public_key
STRIPE_SECRET_KEY=your_secret_key

### Admin Login
# Manually create Admin in rails console
```ruby
# Run in terminal
rails console

Admin.create!(
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123"
)
# Access the admin dashboard at: /admins/sign_in

### ShopMe — built with ❤️ using Rails, Hotwire, and Tailwind CSS.
```yaml
---
Would you like me to output this as a downloadable `README.md` file or paste it into a specific location in your project?
````
