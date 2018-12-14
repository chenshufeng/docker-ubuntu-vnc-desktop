#!/bin/bash


# do for xrdp config
sed -i '/TerminalServerUsers/d' /etc/xrdp/sesman.ini
sed -i '/TerminalServerAdmins/d' /etc/xrdp/sesman.ini
xrdp-keygen xrdp auto
mkdir -p /var/run/xrdp
chmod 2775 /var/run/xrdp
mkdir -p /var/run/xrdp/sockdir
chmod 3777 /var/run/xrdp/sockdir

# set root password for xrdp user login
#echo "root:123456" | chpasswd


# some settings
alias ll="ls -la"


if [ -n "$RESOLUTION" ]; then
    sed -i "s/1024x768/$RESOLUTION/" /usr/local/bin/xvfb.sh
fi

USER=${USER:-root}
HOME=/root
if [ "$USER" != "root" ]; then



    #create user if not exists
    id $USER >& /dev/null
    if [ $? -ne 0 ]
    then

        echo "* enable custom user: $USER"
        useradd --create-home --shell /bin/bash --user-group --groups adm,sudo $USER
        if [ -z "$PASSWORD" ]; then
            echo "  set default password to \"ubuntu\""
            PASSWORD=ubuntu
        fi
        HOME=/home/$USER
        echo "$USER:$PASSWORD" | chpasswd
        cp -r /root/{.gtkrc-2.0,.asoundrc} ${HOME}
        [ -d "/dev/snd" ] && chgrp -R adm /dev/snd

    fi


    # add  $USER to docker group
    # 修改docker group id
    docker_groupid=$(ls -ld /var/run/docker.sock  | awk '{print $4}')

    if [ "$docker_groupid" -gt 0 ] 2>/dev/null ;then
        # docker_groupid 是数字
        groupmod -g $docker_groupid docker
        usermod -aG docker $USER
    else
        usermod -aG $docker_groupid $USER
    fi

    # 兼容 docker server低版本
    echo 'export DOCKER_API_VERSION=1.22' >> /etc/profile

fi
sed -i "s|%USER%|$USER|" /etc/supervisor/conf.d/supervisord.conf
sed -i "s|%HOME%|$HOME|" /etc/supervisor/conf.d/supervisord.conf

# home folder
mkdir -p $HOME/.config/pcmanfm/LXDE/
ln -sf /usr/local/share/doro-lxde-wallpapers/desktop-items-0.conf $HOME/.config/pcmanfm/LXDE/
chown -R $USER:$USER $HOME


# clearup
PASSWORD=
HTTP_PASSWORD=



# start dbus service
/etc/init.d/dbus start

# start ssh service
/etc/init.d/ssh start


exec /bin/tini -- /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
