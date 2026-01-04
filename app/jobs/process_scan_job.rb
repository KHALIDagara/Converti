class ProcessScanJob < ApplicationJob
  def perform(request_id)
    request = WhatsappRequest.find(request_id)
    channel = request.channel 
    qr_status = reqeust.payload.dig("data","status")

    case qr_status 
    when "connected"
      channel.update!(
        status:  :connected,
        whatsapp_number: extract_phone_number(reqeust.payload)
      )
      broadcast_connection_success(channel)
    when "disconnected"
      channel.update!(status: "proccessed")
    end
    request.update!( status: "processed")
  end
end
