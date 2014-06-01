#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# nginxインストール
package "nginx" do
  action :install
end

# nginx有効化
service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# templateからnginx.confを配置
template "nginx" do
  path "/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end

# ディレクトリ作成
dirs_644 = ["/etc/nginx/sites-available","/etc/nginx/sites-enabled"]
dirs_644.each do |directory_name|
  directory "#{directory_name}" do
    owner "root"
    group "root"
    mode 0644
    action :create
  end
end

dirs_755 = ["/var/www","/var/www/#{node['nginx']['root']}","/var/www/#{node['unicorn']['root']}"]
dirs_755.each do |directory_name|
  directory "#{directory_name}" do
    owner "root"
    group "root"
    mode 0755
    action :create
  end
end
# sites設定をtemplateごとに実行
node['nginx']['nginx_sites'].each do |site|
  # templateからsites-available配下に設定ファイルを配置
  template "nginx_sites_available" do
    path "/etc/nginx/sites-available/#{site}"
    source "nginx/#{site}.erb"
    owner "root"
    group "root"
    mode 0644
  end

  # sites-enabled配下へシンボリックリンクを配置
  link "/etc/nginx/sites-enabled/#{site}" do
    to "/etc/nginx/sites-available/#{site}"
    link_type :symbolic
    action :create
    notifies :reload, "service[nginx]"
  end

end

