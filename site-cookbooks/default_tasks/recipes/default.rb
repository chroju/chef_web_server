#
# Cookbook Name:: default_tasks
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# sshdサービスの有効化
service "sshd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# sshd_configの配置
template "sshd_config" do
  path "/etc/ssh/sshd_config"
  source "sshd_config.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, "service[sshd]"
end

# iptablesの設定
iptables_rule "iptables_rule"

