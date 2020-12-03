# frozen_string_literal: true

default["Software"]["base"] = %w[apt-transport-https ca-certificates curl gnupg-agent software-properties-common vim htop ccze neofetch zsh mc git]
default["Software"]["basic"] = %w[vim htop ccze neofetch zsh mc]
default["Software"]["development"] = %w[neovim python3 python3-pip python3-venv ruby-full direnv]
default["Software"]["provisioner"] = %w[terraform vagrant packer ansible atom slack telegram-desktop]
default["Software"]["npm"] = %w[npm aws-cdk jest typescript]
default["Software"]["virtualization"]["rdocker"] = %w[docker docker-engine docker.io containerd runc]
default["Software"]["virtualization"]["docker"] = %w[docker-ce docker-ce-cli containerd.io]
default["Software"]["atom"]["extension"] = %w[atom-ide-ui atom-typescript language-chef script]
default["Software"]["hypervisor"] = %w[virtualbox-6.1]
default["Software"]["pip"] = %w[poetry cfn-flip taskcat]
# default["Software"]["remote"] = %w[
#   https://zoom.us/client/latest/zoom_amd64.deb\
#   https://storage.googleapis.com/golang/getgo/installer_linux
# ]
default["Software"]["remove"] = %w[account-plugin-facebook account-plugin-flickr account-plugin-jabber account-plugin-salut account-plugin-twitter account-plugin-windows-live account-plugin-yahoo aisleriot brltty duplicity empathy empathy-common example-content gnome-accessibility-themes gnome-contacts gnome-mahjongg gnome-mines gnome-orca gnome-screensaver gnome-sudoku gnome-video-effects gnomine landscape-common libreoffice-avmedia-backend-gstreamer libreoffice-base-core libreoffice-calc libreoffice-common libreoffice-core libreoffice-draw libreoffice-gnome libreoffice-gtk libreoffice-impress libreoffice-math libreoffice-ogltrans libreoffice-pdfimport libreoffice-style-galaxy libreoffice-style-human libreoffice-writer libsane libsane-common mcp-account-manager-uoa python3-uno rhythmbox rhythmbox-plugins rhythmbox-plugin-zeitgeist sane-utils shotwell shotwell-common telepathy-gabble telepathy-haze telepathy-idle telepathy-indicator telepathy-logger telepathy-mission-control-5 telepathy-salut totem totem-common totem-plugins printer-driver-brlaser printer-driver-foo2zjs printer-driver-foo2zjs-common printer-driver-m2300w printer-driver-ptouch printer-driver-splix]
