# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           default("student")
#  total_lesson_hours     :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "defaults" do
    let(:new_user) { described_class.new }

    it "defaults role to \"student\"" do
      expect(new_user.role).to eq("student")
    end

    it "defaults total_lesson_hours to 0" do
      expect(new_user.total_lesson_hours).to eq(0)
    end
  end

  describe "validations" do
    it "is valid with all required attributes" do
      expect(user).to be_valid
    end

    it "validates presence of first_name" do
      user.first_name = nil
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it "validates presence of last_name" do
      user.last_name = nil
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it "validates presence of role" do
      user.role = nil
      expect(user).not_to be_valid
      expect(user.errors[:role]).to include("can't be blank")
    end

    it "validates inclusion of role in ROLES" do
      %w[student teacher].each do |valid_role|
        user.role = valid_role
        expect(user).to be_valid, "#{valid_role.inspect} should be valid"
      end

      user.role = "admin"
      expect(user).not_to be_valid
      expect(user.errors[:role]).to include("is not included in the list")
    end

    it "validates presence of total_lesson_hours" do
      user.total_lesson_hours = nil
      expect(user).not_to be_valid
      expect(user.errors[:total_lesson_hours]).to include("can't be blank")
    end

    it "validates numericality of total_lesson_hours >= 0" do
      user.total_lesson_hours = -1
      expect(user).not_to be_valid
      expect(user.errors[:total_lesson_hours]).to include("must be greater than or equal to 0")
    end
  end

  describe "#full_name" do
    it "capitalizes both first and last names" do
      custom_user = build(:user, first_name: "joHN", last_name: "doE")
      expect(custom_user.full_name).to eq("John Doe")
    end

    it "returns a string" do
      expect(user.full_name).to be_a(String)
    end
  end
end
