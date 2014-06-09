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
      gid: deploy[:group]
    })
  end

  ruby_block 'ensure sidekiq started' do
    block do
      true
    end
    notifies :start, 'eye_service[sidekiq]', :immediately
  end

  # Opsworks specific hack
  # Setting a node attribute to disable the restart recipe that will be run as part of the deploy.
  # On opsworks this only sticks for the current chef run.
  ruby_block 'block sidekiq restart' do
    block do
      node.set['opsworks_sidekiq']['disable_restart'] = true
    end
  end
end
