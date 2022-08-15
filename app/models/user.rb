# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true
  validates :password, length: { in: 6..12 },
    unless: Proc.new { |a| a.password.blank? }
  has_secure_password
  validates :email, presence: true, uniqueness: true
  has_one_attached :profile_pic
end
