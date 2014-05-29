Chef Repository for Web Server
=====

Description
-----

This chef repository is for building a web and database server. The following are the details:

* Basic security settings for Linux server
  - sshd_config
  - iptables
* Make some users, and allow them to use `sudo`
* Install nginx
* Install Ruby (later)
* Install PostgreSQL (later)


Recipes
-----

### site-cookbooks

There are three cookbooks.

* `default_tasks` - Basic security settings for Linux server.
* `users` - Make users you describe on data_bags.
* `nginx` - Install and set up Nginx.

### cookbooks

This repository use two third-party cookbooks. You have to install them from Berksfile.

* `sudo` - Set up the sudores file.
* `iptables` - Offer LWRP for setting up iptables.


Usage
-----

At first, you have to install `chef`, `knife-solo` and `berkshelf` from Gem.

### Git clone this repository

```sh
$ git clone git@github.com:chroju/web_server_repo.git
```

### Install cookbooks from Berksfile

```sh
$ berks vendor cookbooks
```

### data_bags

You have to describe users settings which you want to make on your server. Make json file on `data_bags/users/`.

Sample:
```json
{
  "id" : "sample",
  "username" : "sample",
  "group" : "sample, wheel",
  "password" : "hogefuga",
  "key" : "ssh-rsa AAAAB3N..."
}
```

Password is hashed by using `openssl passwd -1 yourpassowrd` command. `wheel` group is allowed to use `sudo` in `users` cookbook, so you add users which you want to use `sudo` in `wheel` group.

### deploy your remote host

```sh
$ knife solo prepare username@ip_address
```

You have to edit json file `nodes/ip_address.json`.

Sample:
```json
{
  "run_list":[
    "recipe[iptables]",
    "recipe[default_tasks]",
    "recipe[users]",
    "recipe[sudo]",
    "recipe[nginx]"
  ],
  "authorization" : {
    "sudo" : {
      "groups" : ["wheel"],
      "passwordless" : "true"
    }
  },
  "sshd" : {
    "Port" : 22,
    "MaxStartups" : 10,
    "PermitRootLogin" : "yes",
    "RSAAuthentication" : "yes",
    "PubkeyAuthentication" : "yes",
    "AuthorizedKeysFile" : ".ssh/authorized_keys",
    "PasswordAuthentication" : "yes"
  },
  "nginx" : {
    "domain" : "www.chroju.com",
    "port" : 80,
    "root" : "home",
    "access_log" : "home.log",
    "error_log" : "home.log",
    "nginx_sites" : [
      "default"
    ]
  },
  "unicorn" : {
    "root" : "Rails-app"
  }
}
```

You cook your server.

```sh
$ knife solo cook username@ip_address
```

Author
-----

### chroju
* http://chroju89.hatenablog.jp
* http://twitter.com/chroju


