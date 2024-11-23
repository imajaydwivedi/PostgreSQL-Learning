# create user
sudo adduser ajay --shell /bin/bash

# grant sudo access
sudo usermod -aG sudo ajay

# check the login details in /etc/passwd should look like below
ajay:x:1002:1002:Ajay Kumar Dwivedi,,,:/home/ajay:/bin/bash

# Disable GUI login manager
sudo touch /home/ajay/.noxsession
sudo chown ajay:ajay /home/ajay/.noxsession

# Restrict GUI login in lightdm
sudo nano /etc/lightdm/users.conf

disallow-ajay=true

