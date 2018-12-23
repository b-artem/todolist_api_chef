override['project']['name'] = 'todolist-api-chef'
override['project']['repository'] = 'git@github.com:b-artem/todolist_api_chef.git'

# Locale ---------------------------------------------------------
override['locale']['lang'] = 'en_US.UTF-8'
override['locale']['lc_all'] = node['locale']['lang']

# Postgresql -----------------------------------------------------
override['postgresql']['version'] = '9.6'
override['postgresql']['users'] = [{
  'name' => 'deployer',
  # The PostgreSQL hash function has the signature format $password$username.
  # For example, if the username was deployer and the password was password,
  # then the command to generate the password would look like this:
  # On Linux: echo md5$(echo -n 'passworddeployer' | md5sum)
  # On macOS: echo md5$(echo -n 'passworddeployer' | md5)

  # To be sure you have corrcet password, do on the server, as it may differs:
  # $ sudo -u postgres psql
  # $ select * from pg_catalog.pg_shadow;
  'encrypted_password' => 'md5700d08bb6193e6c8fb199260503d182d',
  'superuser' => true
}, {
  'name' => node['project']['name'],
  # The PostgreSQL hash function has the signature format $password$username.
  # For example, if the username was deployer and the password was password,
  # then the command to generate the password would look like this:
  # On Linux: echo md5$(echo -n 'passworddeployer' | md5sum)
  # On macOS: echo md5$(echo -n 'passworddeployer' | md5)

  # To be sure you have corrcet password, do on the server, as it may differs:
  # $ sudo -u postgres psql
  # $ select * from pg_catalog.pg_shadow;
  'encrypted_password' => 'md51ec159ad2233218e46a5183ec89d7214',
  'superuser' => false # the user of the project's database must have access only to the project database
}]

override['postgresql']['databases'] = [{
  'name' => "#{node['project']['name']}_#{node['environment']}",
  'owner' => node['project']['name']
}]

override['ruby']['versions'] = ['2.5.3']
override['ruby']['default'] = '2.5.3'

# Node.js -------------------------------------------------------------------------------------------------------------

# To obtain the checksum you can download the file and check it locally.
# $ shasum -a 256 node-vX.X.X.tar.gz

override['nodejs']['version'] = '9.3.0'
override['nodejs']['binary']['checksum'] = 'b7338f2b1588264c9591fef08246d72ceed664eb18f2556692b4679302bbe2a5'

# Nginx ---------------------------------------------------------------------------------------------------------------

# To obtain the checksum you can download the file and check it locally.
# $ shasum -a 256 nginx-X.XX.XX.tar.gz

override['nginx']['source']['version'] = '1.13.7'
override['nginx']['source']['checksum'] = 'beb732bc7da80948c43fd0bf94940a21a21b1c1ddfba0bd99a4b88e026220f5c'

# Monit ---------------------------------------------------------------------------------------------------------------

monit_configs = Chef::EncryptedDataBagItem.load('configs', node.environment)['monit']

override['monit']['username'] = monit_configs['username']
override['monit']['password'] = monit_configs['password']
