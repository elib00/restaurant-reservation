class User < ApplicationRecord
  has_secure_password

  enum role: { customer: 0, admin: 1 }

  has_many :reservations, dependent: :destroy 

  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

  # === Validations ===
  validates :name, presence: true, length: { maximum: 80 }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  validates :contact_number,
            presence: true,
            format: { with: /\A\d+\z/, message: "must contain only numbers" },
            length: { in: 10..15, message: "must be between 10 and 15 digits" }

  validates :password,
            length: { minimum: 8 },
            if: -> { new_record? || !password.nil? }

  before_save :downcase_email
  before_validation :normalize_contact_number

  private

  def downcase_email
    self.email = email.downcase
  end

  def normalize_contact_number
    self.contact_number = contact_number.to_s.gsub(/\D/, "")
  end
end
