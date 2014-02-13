node[:deploy].each do |application, deploy|
  bash 'restart sidekiq' do
    code <<-EOH
    sleep 1
    /usr/local/bin/god restart workers
    EOH
    user 'root'
    action :nothing
  end

  ruby_block 'restart sidekiq later' do
    block do
      true
    end
    notifies :run, 'bash[restart sidekiq]', :delayed
  end
end
