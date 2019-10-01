require 'net/sftp'

host = '192.168.1.8'
user = ''
password = ''
local_file_path = 'small_scale_export.csv'
remote_file_path = 'small_scale_export.csv'

Net::SFTP.start(host, user, :password => password) do |sftp|
  sftp.upload!(local_file_path, remote_file_path)
end
