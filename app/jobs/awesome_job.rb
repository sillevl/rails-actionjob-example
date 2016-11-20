class AwesomeJob < ApplicationJob
  queue_as :default

  def perform(*args)
      loop do
          puts "Hello from my awesome job"
          sleep 5
      end
  end
end
