# frozen_string_literal: true

class JwtService
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload)
    token = JWT.encode(payload, SECRET_KEY)
    token
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    nil
  end
end
