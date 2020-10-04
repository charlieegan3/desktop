#!/usr/bin/env bash

alias ls='ls --color=always --file-type'
alias pbcopy='wl-copy'
alias pbpaste='wl-paste'
alias vi='nvim'
alias vimdiff='nvim -d'

jj() {
  cd $(j -l | awk '{ print $2 }' | fzf)
}
replace_in_folder() {
  find $PWD -type f -not -iwholename '*.git*' -exec sed -i "s/$1/$2/g" {} \;
}
serve() {
  firefox http://localhost:8000 && ruby -run -ehttpd "$1" -p8000
}
kns() {
  local ns=$(kubectl get ns --output=custom-columns=name:.metadata.name --no-headers=true | fzf)
  kubens $ns && echo $ns > ~/.kube/namespace
}
heic_jpg() {
  for f in *.heic; do heif-convert $f $f.jpg; done
}
last_status_string() {
  last_exit="$?"
  if [ "$last_exit" != "0" ]; then echo -n "[$last_exit]"; fi
}
relative_path_to_git_root() {
  path1=$(git root) path2=$(pwd)
  common=$(printf '%s\x0%s' "${path1}" "${path2}" | sed 's/\(.*\).*\x0\1.*/\1/')
  relative_path="${path2/$common/}"
  if  [ $path1 == "$HOME" ]; then
    echo -n "${PWD##*/}";
  elif [ "${#relative_path}" == "0" ]; then
    echo -n "${PWD##*/}";
  else
    if [ ${#relative_path} -ge 20 ]; then
      relative_path="...$(echo $relative_path | rev | cut -c 1-20 | rev)"
    fi
    echo -n "$relative_path";
  fi
}
permissions() {
  sudo find . -type d -exec chmod 0755 {} \;
  sudo find . -type f -exec chmod 0644 {} \;
  sudo find . -type f -iname "*.sh" -exec chmod +x {} \;
}
morning() {
  new_date="$(ruby -e "require 'time'; secs = ((Time.now.hour.to_f / 24) * 120 * 60).to_i;   puts (Time.parse(Time.now.strftime('%Y-%m-%d') + ' 07:00:00 +0100') + secs).strftime('%a %d %b %Y 07:19:43 %Z');")"
  GIT_COMMITTER_DATE=$new_date git commit --date "$new_date"
}
envrc() {
  sudo cat .envrc
  sudo chattr -i .envrc
  vi .envrc
  direnv allow
  sudo chattr +i .envrc
}
gitcd() {
  cd $(git rev-parse --show-toplevel)
}
# TODO find a nicer place for these, maybe in git config
alias gitb="git branch | grep '^\*' | cut -d' ' -f2 | tr -d '\n'"
bran() {
  echo "Current: " $(gitb)
  git checkout $(git b | sed -e 's/^..//' | fzf)
}

