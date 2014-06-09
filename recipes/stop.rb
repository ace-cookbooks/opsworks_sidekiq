node[:deploy].each do |application, deploy|
  ruby_block 'stop sidekiq' do
    block do
      true
    end
    notifies :stop, 'eye_service[sidekiq]', :immediately
  end
end
