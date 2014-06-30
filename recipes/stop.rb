node[:deploy].each do |application, deploy|
  include_recipe 'opsworks_sidekiq::service'

  ruby_block 'stop sidekiq' do
    block do
      true
    end
    notifies :safe_stop, 'eye_service[sidekiq]', :immediately
  end
end
