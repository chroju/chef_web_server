#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2014, chroju
#
# All rights reserved - Do Not Redistribute
#

# wheelグループの作成
group "wheel" do
  gid 10
  action :create
end

# data bagsよりデータ取得
data_ids = data_bag('users')

data_ids.each do |id|
  items = data_bag_item('users', id)
  # data bagsよりグループを作成
  items['groups'].each do |g|
    group g['groupname'] do
      group_name g['groupname']
      gid g['gid']
      action :create
      append true
    end
  end

  # ユーザー作成
  items['users'].each do |u|
    user u['username'] do
      password u['password']
      supports :manage_home => true, :non_unique => false
      group u['group']
      action [:create]
    end

    # ssh公開鍵配置用のディレクトリ作成
    unless u["key"].nil?
      directory "/home/#{u["username"]}/.ssh" do
        owner u["username"]
        group u["username"]
        mode 0700
        action :create
      end

      # ssh公開鍵の配置
      file "/home/#{u["username"]}/.ssh/authorized_keys" do
        owner u["username"]
        mode 0600
        content u["key"]
        action :create_if_missing
      end
    end
  end
end

