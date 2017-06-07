require 'rails_helper'

RSpec.describe 'EventPublisher' do

  setup do
    Bunny = double('Bunny')
    allow_any_instance_of(EventPublisher).to receive(:add_close_connection_handler).and_return true    
  end

  def mock_connection(params)
    @connection = double('connection')
    @channel = double('channel')
    @exchange = double('exchange')
    @queue = double('queue')
    
    allow(Bunny).to receive(:new).with(params[:event_conn]).and_return(@connection)
    allow(@connection).to receive(:start)
    allow(@connection).to receive(:create_channel).and_return(@channel)
    allow(@channel).to receive(:queue).and_return(@queue)
    allow(@channel).to receive(:default_exchange).and_return(@exchange)
  end

  context '#create_connection' do

    it 'initialize methods are called' do
      
      allow_any_instance_of(EventPublisher).to receive(:set_config).and_return true
      
      params = { event_conn: 'event conn', queue_name: 'queue name' }
      ep = EventPublisher.new(params)
      ep.create_connection
      
      expect(ep).to have_received(:set_config)
      expect(ep).to have_received(:add_close_connection_handler)
    end
    it 'does not create connection if connection is already created' do
      params = { event_conn: 'event conn', queue_name: 'queue name' }
      mock_connection(params)      
      ep = EventPublisher.new(params)

      allow(ep).to receive(:connected?).and_return(true)
      allow(ep).to receive(:set_config)
      allow(ep).to receive(:add_close_connection_handler)
      ep.create_connection

      expect(ep).not_to have_received(:set_config)
      expect(ep).not_to have_received(:add_close_connection_handler)      
    end
  end

  context '#set_config' do
    it 'starts a new connection' do

      params = { event_conn: 'event_conn', queue_name: 'queue_name' }
      mock_connection(params)

      expect(@connection).to receive(:start)
      expect(@connection).to receive(:create_channel)
      expect(@channel).to receive(:queue) 
      expect(@channel).to receive(:default_exchange) 

      ep = EventPublisher.new(params)
      ep.create_connection
    end
  end

  context '#publish' do
    setup do
      Bunny = double('Bunny')
      @params = { event_conn: 'event_conn', queue_name: 'queue_name' }
      mock_connection(@params)
      @event_message = instance_double("EventMessage")
      allow(@event_message).to receive(:generate_json).and_return("message")      

      allow(@queue).to receive(:name).and_return(@params[:queue_name])
    end

    it 'publishes a new message to the queue' do
      ep = EventPublisher.new(@params)
      expect(@exchange).to receive(:publish).with('message', routing_key: @params[:queue_name])
      ep.publish(@event_message)
    end
  end
end