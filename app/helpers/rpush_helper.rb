module RpushHelper
  def self.app
    app = Rpush::Apns::App.find_by_name('poke_ios')
    if app.nil?
      apns_file = File.join(Rails.root, 'development.pem')
      app = Rpush::Apns::App.new
      app.name = 'poke_ios'
      app.certificate = File.read(apns_file)
      app.environment = 'development' # APNs environment.
      app.password = '' #Rails.application.credentials.apns_cert_pw
      app.connections = 1
      app.save!
    end
    app
  end
end
