class SignUpControl < Hello::AbstractControl
    
  alias :sign_up :entity

  def sign_up_fields
    # [:email, :password]
    # [:name, :email, :username, :password]
    [:name, :email, :username, :password, :city]
  end
  
  def success
    Hello::RegistrationMailer.welcome(sign_up.credential, sign_up.password).deliver

    active_session = c.create_hello_active_session

    c.respond_to do |format|
      format.html { c.redirect_to c.hello.classic_after_sign_up_path }
      format.json { c.render json: active_session.as_json_api, status: :created }
    end
  end

  def failure
    # SUGGESTION: suggest usernames if username has been taken
    # SUGGESTION: suggest 'forgot password' if email has been taken

    c.respond_to do |format|
      format.html { c.render :sign_up }
      format.json { c.render json: sign_up.errors, status: :unprocessable_entity }
    end
  end

end