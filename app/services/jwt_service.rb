class JwtService
    SECRET_KEY = Rails.application.credentials.secret_key_base
  
    # Encode a payload into a JWT token
    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i # Expiration time in seconds
      JWT.encode(payload, SECRET_KEY)
    end
  
    # Decode a JWT token and verify the payload
    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0] # Decode and get the payload (first item)
      HashWithIndifferentAccess.new(decoded) # Convert to indifferent access hash (symbol or string keys work)
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      raise e
    end
  end
  