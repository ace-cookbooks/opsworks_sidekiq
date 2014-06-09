name             'opsworks_sidekiq'
maintainer       'Ace of Sales'
maintainer_email 'cookbooks@aceofsales.com'
license          'Apache 2.0'
description      'Manages sidekiq on opsworks'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends 'eye'

recipe 'opsworks_sidekiq', 'Launches sidekiq'
recipe 'opsworks_sidekiq::restart', 'Restarts sidekiq'
recipe 'opsworks_sidekiq::stop', 'Stops sidekiq'
