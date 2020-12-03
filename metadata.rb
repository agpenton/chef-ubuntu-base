# frozen_string_literal: true

name "chef-ubuntu-base"
maintainer "Asdrubal Gonzalez"
maintainer_email "agpenton@gmail.com"
license "MIT"
description "Installs/Configures chef-ubuntu-base"
version "0.1.0"
chef_version ">= 15.0"

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook"s page when
# uploaded to a Supermarket.
#
issues_url "https://github.com/agpenton/chef-ubuntu-base/issues"

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook"s page when uploaded to
# a Supermarket.
#
source_url "https://github.com/agpenton/chef-ubuntu-base"

supports "ubuntu", ">= 20.04"

recipe "chef-ubuntu-base::default", "Provisioning operating system (all recipes)"
