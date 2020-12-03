# frozen_string_literal: true

default["Software"]["base"] = %w[apt-transport-https ca-certificates curl\
                                 gnupg-agent software-properties-common vim\
                                 htop ccze neofetch zsh mc git]
default["Software"]["basic"] = %w[vim htop ccze neofetch zsh mc]
default["Software"]["development"] = %w[neovim python3 python3-pip python3-venv\
                                        ruby-full terraform vagrant packer\
                                        ansible atom]
default["Software"]["npm"] = %w[npm aws-cdk jest typescript]
default["Software"]["virtualization"]["rdocker"] = %w[docker docker-engine\
                                                      docker.io containerd runc]
default["Software"]["virtualization"]["docker"] = %w[docker-ce docker-ce-cli\
                                                     containerd.io]
default["Software"]["atom"]["extension"] = %w[atom-ide-ui atom-typescript\
                                              language-chef script]
