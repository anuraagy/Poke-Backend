class JSONWebToken
  
  def self.encode(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def self.decode(token)
    begin
      HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.credentials.secret_key_base)[0])
    rescue
      nil
    end
  end
end