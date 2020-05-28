class FixStatusesClientFeedbackRequired < (Rails.version < '5.1') ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def change
    Issue.connection.execute("UPDATE issues SET status_id = 4 WHERE status_id = 15")
  end
end
