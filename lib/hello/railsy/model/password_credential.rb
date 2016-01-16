module Hello
  module PasswordCredential
    extend ActiveSupport::Concern


    included do
      attr_reader :password
      validates_presence_of :password, on: :create
      # validates_presence_of :digest

      # before_destroy :cannot_destroy_last_password_credential
      validate :hello_validations
    end

    def password=(value)
      # puts "password=('#{value}')".blue
      if value.blank?
        self.digest = @password = nil
      end
      @password = value

      self.digest = password_encryption_extension.encrypt(value)
    end

    def password_is?(plain_text_password)
      password_encryption_extension.check(self, plain_text_password)
    end

    def password_encryption_extension
      Hello.configuration.extensions.encrypt_password
    end

    def set_generated_password
      self.password = Token.single(4) # 8 chars
    end


    private

    def hello_validations
      return true if not digest_changed?

      return false if errors[:password].any?
      c = Hello.configuration

      validates_length_of :password, in: c.password_length
      return false if errors[:password].any?

      validates_format_of :password, with: c.password_regex
      return false if errors[:password].any?
    end

    # # TODO: code for multiple passwords
    # def cannot_destroy_last_password_credential
    #   return if hello_is_user_being_destroyed?
    #   return if not is_last_password_credential?
    #   errors[:base] << "must have at least one credential"
    #   false
    # end

    # def is_last_password_credential?
    #   user.password_credentials.count == 1
    # end



  end
end
