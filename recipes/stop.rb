node[:deploy].each do |application, deploy|
  bash 'stop sidekiq' do
    code <<-EOH
    sleep 1
    /usr/local/bin/god stop workers
    EOH
    user 'root'
    action :run
  end
end
