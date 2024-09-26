class JwtService
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload)
    token = JWT.encode(payload, SECRET_KEY)
    Rails.logger.info("Token encoded with payload: #{payload}")
    token
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    Rails.logger.info("Token decoded: #{decoded}")
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    Rails.logger.error("Token decoding failed: #{e.message}")
    nil
  end
end
