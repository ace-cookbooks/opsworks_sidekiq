node[:deploy].each do |application, deploy|
  include_recipe 'opsworks_sidekiq::service'

  ruby_block 'restart sidekiq later' do
    block do
      true
    end
    notifies :restart, 'eye_service[sidekiq]', :delayed
  end
end
