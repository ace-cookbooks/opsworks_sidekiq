service_list = [resources('eye_service[sidekiq]')].flatten
if service_list.size != 1
  eye_service 'sidekiq' do
    supports [:start, :stop, :safe_stop, :restart, :safe_restart, :enable, :load]
    user_srv_uid 'root'
    user_srv_gid 'root'
    action :nothing
  end
end
