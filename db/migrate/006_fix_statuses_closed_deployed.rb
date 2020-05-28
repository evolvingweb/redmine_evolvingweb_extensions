class FixStatusesClosedDeployed < (Rails.version < '5.1') ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def change
    Issue.connection.execute("UPDATE issues SET status_id = 13 WHERE status_id = 17")
  end
end
