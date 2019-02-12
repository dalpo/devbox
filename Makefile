.PHONY: setup_python

setup_python:
ifneq (,$(wildcard ./env/bin/python))
	echo "Environment already setup"
else
	echo "Setup python3 virtual env";
	virtualenv ./env
	virtualenv -p python3 env
endif

# .PHONY: activate_env
# 
# activate_env:
# 	include ./env/bin/activate

.PHONY: install_dependencies

install_dependencies:
	pip install -r ./requirements.txt
	vagrant plugin install vagrant-vbguest
	vagrant plugin install vagrant-disksize

.PHONY: provision

provision:
	export DEVBOX_DISKSIZE="30GB"
	export DEVBOX_CPUS=6
	vagrant up
	vagrant provision
