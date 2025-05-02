class DropSolidQueueJobs < ActiveRecord::Migration[8.0]
  def change
    drop_table :solid_queue_jobs
  end
end
