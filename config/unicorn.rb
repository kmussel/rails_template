APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
pid APP_ROOT + "/tmp/pids/unicorn.pid"
timeout 90
preload_app true
listen APP_ROOT + "/tmp/sockets/unicorn.sock", :backlog => 64

stderr_path APP_ROOT + '/log/unicorn.log'
stdout_path APP_ROOT + '/log/unicorn.log'

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # AR
  ActiveRecord::Base.connection.disconnect!

  # Redis
  begin
    Timeout.timeout(2) { 
      REDIS.quit 
      if defined?(Resque)
        Resque.redis.quit
        Rails.logger.info('Disconnected from Redis')
      end
    }
    
  rescue Exception
    # This likely means the redis service is down
  end
end

after_fork do |server, worker|

  
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  # AR
  ActiveRecord::Base.establish_connection

  # Redis
  uri = URI.parse(ENV["REDIS_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)


  if defined?(Resque)
    Resque.redis = ENV['REDIS_URL']
    Rails.logger.info('Connected to Redis')
  end


end
