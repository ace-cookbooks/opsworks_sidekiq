#
# Cookbook Name:: opsworks_sidekiq
# Recipe:: default
#
node[:deploy].each do |application, deploy|
  execute 'bundle binstubs sidekiq' do
    user deploy[:user]
    group deploy[:group]
    environment(deploy[:environment])
    cwd deploy[:current_path]
    command "#{deploy[:bundler_binary]} binstubs sidekiq"
  end

  eye_app 'sidekiq' do
    template 'eye-sidekiq.conf.erb'
    cookbook 'opsworks_sidekiq'
    variables({
      env: deploy[:environment],
      dir: deploy[:current_path],
      uid: deploy[:user],
      gid: deploy[:group],
      rails_env: deploy[:rails_env]
    })
  end

  ruby_block 'restart sidekiq on deploy' do
    block do
      true
    end
    notifies :restart, 'eye_service[sidekiq]', :delayed
    not_if { node[:opsworks][:activity] == 'setup' }
  end

  execute 'move sidekiq config into place' do
    user deploy[:user]
    group deploy[:group]
    environment(deploy[:environment])
    cwd deploy[:current_path]
    command 'cp -f config/sidekiq.fulfillment.yml config/sidekiq.yml'
    only_if { node[:opsworks][:activity] != 'setup' && node[:opsworks][:instance][:layers].include?('fulfillment') }
  end
end
