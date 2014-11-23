#
# Cookbook Name:: subsonic
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# javaのインストール
package "java" do
  action :install
end

# subsonicのrpmファイル取得
remote_file "tmp/subsonic.rpm" do
  source "#{node['subsonic']['remote_uri']}"
end

# subsonicインストール
package "subsonic" do
  action :install
  provider Chef::Provider::Package::Rpm
  source "tmp/subsonic.rpm"
end

# nginx有効化
service "subsonic" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# iptbalesにsubsonicのポート許可追加
iptables_rule "iptables_subsonic"
