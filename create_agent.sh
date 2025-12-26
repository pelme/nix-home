#!/bin/bash

USERNAME="agent"
GROUPNAME="agent"
REALNAME="Agent User"
USER_UID=503  # Change if this UID is already taken
GROUP_GID=503  # Change if this GID is already taken
YOUR_USERNAME="$(whoami)"  # Your current username

# Create the group
echo "Creating group: $GROUPNAME"
sudo dscl . -create /Groups/$GROUPNAME
sudo dscl . -create /Groups/$GROUPNAME PrimaryGroupID $GROUP_GID
sudo dscl . -create /Groups/$GROUPNAME RealName "$GROUPNAME"

# Create the user account
echo "Creating user: $USERNAME"
sudo dscl . -create /Users/$USERNAME
sudo dscl . -create /Users/$USERNAME UserShell /bin/bash
sudo dscl . -create /Users/$USERNAME RealName "$REALNAME"
sudo dscl . -create /Users/$USERNAME UniqueID $USER_UID
sudo dscl . -create /Users/$USERNAME PrimaryGroupID $GROUP_GID
sudo dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME

# Create the home directory
echo "Creating home directory"
sudo createhomedir -c -u $USERNAME

# Add your current user to the agent group
echo "Adding $YOUR_USERNAME to $GROUPNAME group"
sudo dscl . -append /Groups/$GROUPNAME GroupMembership $YOUR_USERNAME

# Change group ownership of the home directory
echo "Setting group permissions on home directory"
sudo chgrp -R $GROUPNAME /Users/$USERNAME

# Set group read/write permissions
sudo chmod -R g+rw /Users/$USERNAME

echo "Done! User 'agent' created and you have read/write access to /Users/agent"
