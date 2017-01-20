# Mount healcheck url at '/health'
OkComputer.mount_at = 'health'

# Mount the application revision check
OkComputer::Registry.register 'app_version', OkComputer::AppVersionCheck.new
