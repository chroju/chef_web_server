#
# Cookbook Name:: postgres
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# パッケージダウンロード
remote_file "/tmp/postgres.rpm" do
  source node['postgres']['package_name']
  checksum node['postgres']['checksum']
end

# rpmインストール
rpm_package "postgresql-#{node['postgres']['version']}" do
  action :install
  source "/tmp/postgres.rpm"
end

version_undotted = node['postgres']['version'].delete(".")
yum_package "postgresql#{version_undotted}-server.x86_64" do
  action :install
end

# 初期化
execute "postgresql-init" do
  not_if "test -f #{node['postgres']['version_file_path']}"
  command "service postgresql-#{node['postgres']['version']} initdb"
  action :run
end

# pd_hba.confを設定
template "pb_hba" do
  path "/var/lib/pgsql/#{node['postgres']['version']}/data/pb_hba.conf"
  source "pb_hba.conf.erb"
  owner "root"
  group "root"
  mode 0600
end

# サービス起動
service "postgresql-#{node['postgres']['version']}" do
  action [:enable, :restart]
end

