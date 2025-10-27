# Clear existing data (optional, for testing)
Table.destroy_all
User.destroy_all

# --- Users ---
admin = User.create!(
  name: "Admin User",
  email: "admin@orchidoasis.com",
  password: "password123",
  password_confirmation: "password123",
  role: :admin,
  contact_number: "0000000000"
)

customer = User.create!(
  name: "John Doe",
  email: "john@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: :customer,
  contact_number: "09123456789"
)

# --- Tables ---
tables = [
  { name: "Orchid", capacity: 2, location: "Window", shape: "Round", description: "Cozy window table for 2, inspired by the Orchid." },
  { name: "Tulip", capacity: 4, location: "Center", shape: "Rectangle", description: "Spacious center table for 4, vibrant like a Tulip." },
  { name: "Lotus", capacity: 6, location: "Patio", shape: "Round", description: "Outdoor patio table for 6, serene like the Lotus flower." },
  { name: "Daisy", capacity: 2, location: "Corner", shape: "Square", description: "Quiet corner table for 2, cheerful like a Daisy." }
]

tables.each { |t| Table.create!(t) }
