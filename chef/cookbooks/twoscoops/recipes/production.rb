#
# Cookbook Name:: twoscoops
# Recipe:: production
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node['twoscoops']['database']['engine'] == 'django.db.backends.postgresql_psycopg2'
  include_recipe "database::postgresql"

  database_connection_info = {
    :host => 'localhost',
    :username => 'postgres',
    :password => node['postgresql']['password']['postgres']
  }

  postgresql_database node['twoscoops']['project_name'] do
    connection database_connection_info
    provider Chef::Provider::Database::Postgresql
    action :create
  end
end

directory "/vagrant/logs" do
  action :create
  mode 00755
end

template "/vagrant/#{node['twoscoops']['project_name']}/#{node['twoscoops']['project_name']}/settings/database.py" do
  source "database.py.erb"
  mode 00644
end

template "/etc/default/#{node['twoscoops']['project_name']}" do
  source "environment.erb"
  mode 00644
end

execute "pip-install-requirements" do
  cwd "/vagrant"
  command "pip install -r requirements/production.txt"
end

bash "django-syncdb" do
  cwd "/vagrant/#{node['twoscoops']['project_name']}"
  command "source /etc/default/#{node['twoscoops']['project_name']} && python manage.py syncdb --noinput"
end

bash "django-createcachetable" do
  cwd "/vagrant/#{node['twoscoops']['project_name']}"
  command "source /etc/default/#{node['twoscoops']['project_name']} && python manage.py createcachetable application_cache"
  only_if do
    con = PGconn.connect("host=localhost user=postgres password=#{node['postgresql']['password']['postgres']} dbname=#{node['twoscoops']['project_name']}")
    res = con.exec("SELECT count(*) FROM information_schema.tables WHERE table_name = 'application_cache'")
    res.entries[0]['count']
  end
end

directory "/tmp/twoscoops/fixtures" do
  recursive true
  action :create
  mode 00755
end

template "/tmp/twoscoops/fixtures/createsuperuser.json" do
  source "createsuperuser.json.erb"
end

bash "django-createsuperuser" do
  cwd "/vagrant/#{node['twoscoops']['project_name']}"
  command "source /etc/default/#{node['twoscoops']['project_name']} && python manage.py loaddata /tmp/twoscoops/fixtures/createsuperuser.json --settings=#{node['twoscoops']['project_name']}.settings.production"
end

bash "django-migrate" do
  cwd "/vagrant/#{node['twoscoops']['project_name']}"
  command "source /etc/default/#{node['twoscoops']['project_name']} && python manage.py migrate"
end

include_recipe "nginx"

template "#{node['nginx']['dir']}/sites-enabled/#{node['twoscoops']['project_name']}" do
  source "nginx.conf.erb"
  mode 0440
  owner "root"
  group "root"  
end

nginx_site node['twoscoops']['project_name'] do
  action :enable
end

include_recipe "supervisor"

supervisor_service "uwsgi" do
  command "uwsgi --uwsgi-socket :8080 --wsgi-file #{node['twoscoops']['project_name']}/wsgi.py"
  autostart true
  directory "/vagrant/#{node['twoscoops']['project_name']}"
  stdout_logfile "/vagrant/logs/uwsgi.log"
  stderr_logfile "/vagrant/logs/uwsgi_error.log"
  environment "SECRET_KEY" => node[:twoscoops][:secret_key],
              "DJANGO_SETTINGS_MODULE" => "#{node['twoscoops']['project_name']}.settings.production"
  action :enable
end
