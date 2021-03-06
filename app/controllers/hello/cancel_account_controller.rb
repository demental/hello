module Hello
  class CancelAccountController < ApplicationController
    include Hello::Concerns::CancelAccountOnSuccess
    include Hello::Concerns::CancelAccountOnFailure

    dont_kick :user
    sudo_mode

    # GET /hello/cancel_account
    def index
    end

    # POST /hello/cancel_account
    def cancel
      @cancel_account = CancelAccountEntity.new

      if current_user.cancel_account
        flash[:notice] = @cancel_account.success_message
        on_success
      else
        flash.now[:alert] = @cancel_account.alert_message
        on_failure
      end
    end
  end
end
