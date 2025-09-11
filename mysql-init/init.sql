CREATE TABLE IF NOT EXISTS Product (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  price DECIMAL(12,2)
);

INSERT INTO Product (name, price) VALUES
('Mobile', 100),
('Tablet', 200),
('Laptop', 300.00);
