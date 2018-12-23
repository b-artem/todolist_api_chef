include_recipe 'imagemagick::devel'

directory '/etc/ImageMagick' do
  owner 'root'
  group 'root'
  mode '0755'
end
