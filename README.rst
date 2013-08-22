========================
django-twoscoops-project
========================

A project template for Django 1.5 with built-in support for Vagrant and Chef.

To use this project follow these steps:

#. Create your working environment
#. Install Django
#. Create the new project using the django-two-scoops template
#. Install additional dependencies
#. Use the Django admin to create the project

*note: these instructions show creation of a project called "icecream".  You
should replace this name with the actual name of your project.*

Working Environment
===================

This project template has been modified for developers using isolated virtual machines managed by vagrant. It is still recommended that you install virtualenv on the host machine to isolate your installation of django. We still need django on the host machine to create the new project from this template.

Virtual Box
-----------

https://www.virtualbox.org/wiki/Downloads

Vagrant
-------

Vagrant (1.2+) - http://vagrantup.com/downloads

Vagrant Omnibus
---------------

vagrant-omnibus is a plugin that ensures the appropriate version of chef get installed.
Once you have installed vagrant, run this command::

    $ vagrant plugin install vagrant-omnibus

Vagrant Berkshelf
-----------------

Install the berkshelf gem::

    $ gem install berkshelf

vagrant-berkshelf is a plugin that ensures that all cookbook dependancies are dealt with.
To install vagrant-berkshelf, run this command::

    $ vagrant plugin install vagrant-berkshelf

Vagrant AWS
-----------

If you want to deploy using the AWS provider you will first need to install the plugin by running this command::

    $ vagrant plugin install vagrant-aws

Local Virtualenv
----------------

First, make sure you are using virtualenv (http://www.virtualenv.org). Once
that's installed, create your virtualenv::

    $ virtualenv --distribute icecream

You will also need to ensure that the virtualenv has the project directory
added to the path. Adding the project directory will allow `django-admin.py` to
be able to change settings using the `--settings` flag.

Virtualenv with virtualenvwrapper
--------------------------

In Linux and Mac OSX, you can install virtualenvwrapper (http://virtualenvwrapper.readthedocs.org/en/latest/),
which will take care of managing your virtual environments and adding the
project path to the `site-directory` for you::

    $ mkdir icecream
    $ mkvirtualenv -a icecream icecream-dev
    $ cd icecream && add2virtualenv `pwd`

Windows
----------

In Windows, or if you're not comfortable using the command line, you will need
to add a `.pth` file to the `site-packages` of your virtualenv. If you have
been following the book's example for the virtualenv directory (pg. 12), then
you will need to add a python pathfile named `_virtualenv_path_extensions.pth`
to the `site-packages`. If you have been following the book, then your
virtualenv folder will be something like::

`~/.virtualenvs/icecream/lib/python2.7/site-directory/`

In the pathfile, you will want to include the following code (from
virtualenvwrapper):

    import sys; sys.__plen = len(sys.path)
    /home/<youruser>/icecream/icecream/
    import sys; new=sys.path[sys.__plen:]; del sys.path[sys.__plen:]; p=getattr(sys,'__egginsert',0); sys.path[p:p]=new; sys.__egginsert = p+len(new)

Installing Django
=================

To install Django in the new virtual environment, run the following command::

    $ pip install django

Creating your project
=====================

To create a new Django project called '**icecream**' using
django-twoscoops-project, run the following command::

    $ django-admin.py startproject --template=https://github.com/jwmarshall/django-twoscoops-project/archive/develop.zip --name=Vagrantfile --extension=py,rst,html icecream

Creating your virtual machine
=============================

To create a new virtual machine running your project, run the following command::

    $ cd icecream
    $ vagrant up

Creating a new virtual machine for the first time can take several minutes. Once completed you can login by running the following command::

    $ vagrant ssh

Your project is already running too! Visit the following URL::

    http://localhost:8080

You can login to the django admin with the following username and password::

    user: vagrant
    pass: vagrant

All of the project files are all kept on your host computer and mounted inside the virtual machine. Move into your new project directory and start coding::

    $ cd /vagrant/icecream

Installation of Dependencies
=============================

All dependancies should be satisfied by the time vagrant up completes.

Manually installing dependencies:

In development::

    $ pip install -r requirements/local.txt

For production::

    $ pip install -r requirements.txt

*note: We install production requirements this way because many Platforms as a
Services expect a requirements.txt file in the root of projects.*

Acknowledgements
================

- Many thanks to Randall Degges for the inspiration to write the book and django-skel.
- All of the contributors_ to this project.

.. _contributors: https://github.com/twoscoops/django-twoscoops-project/blob/master/CONTRIBUTORS.txt
