class ApplicationController < ActionsController::Base 
  skip_before_action :verify_authenticity_token


  def webhook
    channel = Channel.find_by!(instance_name: params[:instance_name])
    ##you may ask what if we don't have the channnel yet in the database 
    ## which means it's not created yet via the create aciton in the channel controller 
    ## which means we don't need to listen for it's events 
    request = channel.whatsapp_requests.create!(
      payload: webhook_params.to_h,
      event_type: extract_event_type(webhook_params)
    )

    WhatsappEventRouter.route(request)

    head: ok 
  rescue ActiveRecord::RecordNotFound
    head: :not_found
  end


  def extract_event_type 
    webhook_params.dig(:event) || "unknown" 
  end

  def webhook_params
    params.permit! 
  end
end
