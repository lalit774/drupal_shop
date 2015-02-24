# Obtain environment
current_DIR=$(readlink -f ./.)
current_DIR=${current_DIR##*/}
#environment=${current_DIR%%.*}

# Verify environment pattern
#if [[ $environment != dev* ]];then
 # echo "Please execute script from a DEV environment"
  #exit
#fi

# Delete settings.php
chmod 777 sites/default/settings.php
rm -rf sites/default/settings.php

# Refresh git develop branch (or some other branch)
if [ -z "$1" ]; then
  git checkout develop
  git pull origin develop
  site_name='develop'
else
  git checkout $1
  git pull origin $1
  site_name=$1
fi

db_name=${current_DIR}

# Install Drupal version
echo Site name will be ${site_name}
drush site-install minimal -y --account-name=${db_name} --account-pass=${db_name} --db-url=mysql://root:nothing@localhost/${db_name} --site-name=${site_name}

# Install/Run initializer module
drush en initializer -y

# Rebuild Permissions
drush eval 'node_access_rebuild();' 

#Change permission for files system and other sensitive locations
chmod 755 sites/default
chmod 755 sites/default/settings.php
chmod -R 777 sites/default/files
