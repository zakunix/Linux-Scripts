#!/usr/bin/bash
# Description: Generate and set a random hostname on Linux
# Usage: set-random-hostname

__set_random_hostname() {

  # set a prefix if you'd like (thx for the idea @czerniachowicz)
  local prefix="fedora"

  # set the size of the randomly generated portion
  local random_size="12"

  # generate new hostname
  if [ -n "$prefix" ]; then
    local new_hostname="$(echo ${prefix} | sed -e 's/[^[:alnum:]]//g')-$(head -n1 < <(fold -w${random_size} < <(tr -cd 'a-z0-9' < /dev/urandom)))"
  else
    local new_hostname="$(head -n1 < <(fold -w${random_size} < <(tr -cd 'a-z0-9' < /dev/urandom)))"
  fi

  # ensure new hostname is not too long
  if [ ${#new_hostname} -gt 63 ]; then
    new_hostname=${new_hostname:0:63}
  fi

  # set new hostname
  hostnamectl set-hostname "$new_hostname"
  sed -i "/^127\.0\.1\.1\s/c\127.0.1.1       $new_hostname" /etc/hosts

}

__set_random_hostname