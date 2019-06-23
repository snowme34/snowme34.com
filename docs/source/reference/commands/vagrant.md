# Vagrant

vagrant has

* `Vagrantfile`
* `.vagrant` directory

The `Vagrantfile` "marks" a project directory of a vagrant box and this project directory is shared
as `/vagrant` in the virtual machine (default via VirtualBox shared folder).

[Discover Vagrant Boxes](https://app.vagrantup.com/boxes/search)

## Commands

```bash
vagrant status
vagrant global-status <--prune>
```

box

```bash
vagrant box list
vagrant box add <some-box>
vagrant box add <some-name> <some-url>
vagrant box outdated
```

init, no box for empty config

```bash
vagrant init <some-box>
```

start

```bash
vagrant provision          # run provisioners, only auto do this on first up
vagrant up                 # auto provision if first up
vagrant up --provision
vagrant reload             # restart and load config, skip initial import
vagrant reload --provision
```

in

```bash
vagrant ssh <some-name>
```

suspend

```bash
vagrant suspend
vagrant resume
```

shut down

```bash
vagrant halt
```

remove instance

```bash
vagrant destroy <-f>
```

remove box

```bash
vagrant box remove <some-box>
```

package into a box

```bash
vagrant package --output <some-new-box-name.box>
```

```bash
vagrant push
```

[snapshot](https://www.vagrantup.com/docs/cli/snapshot.html), DO NOT MIX TWO SETS (either push/pop or save/restore)

* `[vm-name]` may be `default`

```bash
vagrant snapshot push
vagrant snapshot pop  --no-delete --no-start

vagrant snapshot save    [vm-name] NAME
vagrant snapshot restore [vm-name] NAME
vagrant snapshot delete  [vm-name] NAME
```

## Vagrantfile

* [Getting Started - Vagrant by HashiCorp](https://www.vagrantup.com/intro/getting-started/index.html)
* [Vagrantfile - Vagrant by HashiCorp](https://www.vagrantup.com/docs/vagrantfile/)

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.box_version = "1.1.0"
  config.vm.box_url = "https://vagrantcloud.com/hashicorp/precise64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 999
    vb.cpus = 1
    #vb.gui = true
  end

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.network :forwarded_port, guest: 80, host: 4567
  config.vm.network :forwarded_port, guest: 443, host: 5678, auto_correct: true
end
```

## Plug-ins

* vagrant-share

```bash
vagrant share
```

* vagrant-auto_network

## Read More

* [Vagrant Cheat Sheet](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4)
* [This is a VAGRANT cheat sheet](https://gist.github.com/carlessanagustin/69d65ca1110c146598a9)
