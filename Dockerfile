FROM archlinux:base-devel

RUN pacman -Syu --noconfirm &&\
  pacman -S --noconfirm wget unzip git pyalpm python-commonmark asp cmake svn mercurial ruby ruby-faraday ruby-faraday-middleware \
  sudo go nodejs nodejs-lts-gallium rust pacman-contrib &&\
  yes | pacman -Scc

RUN useradd -m -p $(openssl passwd -1 password) user && \
  echo "user ALL=(ALL) NOPASSWD:/usr/bin/pacman" >> /etc/sudoers && \
  echo "user ALL=(ALL) NOPASSWD:/usr/sbin/pikaur" >> /etc/sudoers && \
  echo "user ALL=(ALL) NOPASSWD:/usr/sbin/ncdu" >> /etc/sudoers

USER user

RUN mkdir -p /home/user/.cache/pikaur/pkg &&\
  mkdir /home/user/go

VOLUME /home/user/.cache/pikaur/pkg
VOLUME /home/user/go
VOLUME /tmp
VOLUME /mnt

RUN mkdir /home/user/pikaur &&\
  cd /home/user/pikaur &&\
  curl  https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD\?h\=pikaur | tee PKGBUILD &&\
  makepkg -s &&\
  mv pikaur-*-any.pkg.tar.zst /home/user &&\
  cd /home/user &&\
  rm -rf pikaur

RUN sudo pacman -U --noconfirm /home/user/pikaur-*-any.pkg.tar.zst

RUN mkdir /home/user/builder

WORKDIR /home/user/builder

ADD builder builder/
ADD builder-cli .
