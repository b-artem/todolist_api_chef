name 'web'
description 'Web setup'

run_list 'recipe[app-redis]',
         'recipe[app-ruby]',
         'recipe[app-nodejs]',
         # 'recipe[app-imagemagick]',
         'recipe[app-nginx]',
         'recipe[app-monit::redis]',
         'recipe[app-monit::nginx]',
         'recipe[app-monit::puma]'
         # TODO: enable if needed
         # 'recipe[app-monit::sidekiq]'
