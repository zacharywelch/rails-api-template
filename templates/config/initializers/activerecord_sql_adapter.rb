if ActiveRecord::Base.connection.class.name.match(/SQLServerAdapter/)
  ActiveRecord::ConnectionAdapters::SQLServerAdapter.use_output_inserted = false
end
