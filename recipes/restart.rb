node[:deploy].each do |application, deploy|
  ruby_block 'restart sidekiq later' do
    block do
      true
    end
    notifies :restart, 'eye_service[sidekiq]', :delayed
    not_if { node['opsworks_sidekiq']['disable_restart'] == true }
  end
end
