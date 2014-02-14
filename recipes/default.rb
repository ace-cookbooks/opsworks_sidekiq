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
    command "#{deploy[:bundle_binary]} binstubs sidekiq"
  end

  pid_file = File.join(deploy[:deploy_to], 'shared', 'pids', 'sidekiq.pid')
  god_monitor 'sidekiq' do
    template_cookbook 'god'
    template_source 'god_monitor.erb'
    variables({
      :name => 'sidekiq',
      :group => 'workers',
      :env => deploy[:environment],
      :uid => deploy[:user],
      :dir => deploy[:current_path],
      :start => "cd #{deploy[:current_path]}; #{File.join(deploy[:current_path], 'bin', 'sidekiq')} -C config/sidekiq.yml -e #{deploy[:rails_env]} -P #{pid_file} 2>&1 | logger -t sidekiq",
      :stop => "cd #{deploy[:current_path]}; #{File.join(deploy[:current_path], 'bin', 'sidekiqctl')} stop #{pid_file} 60",
      :memory_max => (1434 * 1024)
    })
  end
end
