class ChannelController < ActionController::Base

  def index 
    # get all the channels with paginations 
    # return them as array of jsons 
  end 

  def show
    # get the channel id from the request 
    # search the database 
    # return the attributes as json 
  end 


  def new 
  end 

  def create
    @channel = Channel.new(channel_params)
    @channel.instance_name =  generate_instance_name 
    
    response = EvolutionApiClient.create_instance(@channel.instance_name)

    if response.success? 
      @channel.qr_code = response.qr_code 
      @channel.status = :pending_scan 
      @channel.save! 

      redirect_to @channel, notice: "Scan the qr Code To connect "
    else 
      render :new, status: :unprocessable_entity
    end 

    # set the variables from the reqeust 
    #make_request_to_evolution_api 
    # if success ? 
    # do update 
  end 

  def edit 
    #set the variables from the request 
    # make_request_to_evolution_api 
    # if success 
    # update 
  end 

  def update 
    # if update successfull 
    # return a status with success 
  end

  private 


  def generate_instance_name
    "channel_#{SecureRandom.hex(8)}"
  end 

  def set_channel
    @channel = Channel.find(params.expect(:id))
  end

  def channel_params 
    params.expect( channel: [
    :name, :whatsapp_number , :is_scanned? , :business_name 
  ])

  end 

  end
