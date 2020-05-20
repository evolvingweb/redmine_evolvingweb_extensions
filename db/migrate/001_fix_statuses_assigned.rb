class FixStatusesAssigned < (Rails.version < '5.1') ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def change
    Issue.connection.execute("UPDATE issues SET status_id = 1 WHERE status_id = 2")
  end
end
