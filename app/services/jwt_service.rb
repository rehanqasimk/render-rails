class JwtService
  # Get secret key from credentials, or use a fallback in development
  SECRET_KEY = Rails.application.credentials.secret_key_base ||
               ENV.fetch("SECRET_KEY_BASE") {
                 Rails.env.production? ? nil : "2b1d74a78a5b08e758c6dc04adba4cd5071c1c7d7e6d1b8ebebe5f86c90f8c9d12ed7b01ab22317c8a1f9e8995817e80d2a8fa95c4d1f2944e2d6a289f69ab1d"
               }

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
