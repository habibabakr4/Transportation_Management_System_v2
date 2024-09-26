# spec/factories/drivers.rb

FactoryBot.define do
    factory :driver do
      email { "driver@example.com" }
      password { "password" }
      password_confirmation { "password" }
    end
  end
  