class CleanupActivities < (Rails.version < '5.1') ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def change
    # Emails - del.
    Issue.connection.execute("UPDATE time_entries SET activity_id = 12 WHERE activity_id IN (50, 55, 59, 63, 67, 71, 75, 79, 83, 87, 91, 98, 102, 106)")
    # Copy Writing - del.
    Issue.connection.execute("UPDATE time_entries SET activity_id = 12 WHERE activity_id IN (51, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 95, 99, 103, 107)")
    # Revisions - del.
    Issue.connection.execute("UPDATE time_entries SET activity_id = 12 WHERE activity_id IN (38, 48, 29, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 97, 101, 105, 109)")
    # Themming - del.
    Issue.connection.execute("UPDATE time_entries SET activity_id = 9 WHERE activity_id IN (37, 47, 17)")
    # Module configuration - del.
    Issue.connection.execute("UPDATE time_entries SET activity_id = 9 WHERE activity_id IN (36, 46, 16, 57, 61, 65, 69, 73, 77, 81, 85, 89, 93, 96, 100, 104, 108)")
    # Planning - del.
    Issue.connection.execute("UPDATE time_entries SET activity_id = 18 WHERE activity_id = 14")
    # Maintenance - del.
    Issue.connection.execute("UPDATE time_entries SET activity_id = 18 WHERE activity_id IN (26, 33, 43)")
  end
end
