web: bundle exec unicorn_rails -p ${PORT:="3000"} -E ${RAILS_ENV:="development"} -c ${UNICORN_CONFIG:="config/unicorn.rb"}
worker: bundle exec rake resque:work QUEUE=mail_notifications,post_receive,mailer,system_hook,project_web_hook,common,default,gitlab_shell,subscribe
#faye: bundle exec rackup private_pub.ru -s thin -E production
