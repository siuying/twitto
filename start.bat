call config.bat
rackup -p 80 -s webrick config.ru BITLY_USER=%BITLY_USER% BITLY_KEY=%BITLY_KEY% OAUTH_KEY=%OAUTH_KEY% OAUTH_SECRET=%OAUTH_SECRET% 