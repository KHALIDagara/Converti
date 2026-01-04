class ProcessMessageJob < ApplicationJob
    def perform(request_id)
      request = WhatsappRequest.find(request_id)
      channel = request.channel

      message = request.payload.dig("data", "message", "conversation")
      sender = request.payload.dig("data", "key", "remoteJid")
     
      response = Agents::BaseAgent.ask(message)
      EvolutionApiClient.send_message(
        instance_name: channel.isntance_name,
        to: sender,
        text: response 
      )

      request.update!(status: "proccessed")
    end 
end


