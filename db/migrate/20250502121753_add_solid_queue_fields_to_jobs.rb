class AddSolidQueueFieldsToJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :solid_queue_jobs, :queue_name, :string
    add_column :solid_queue_jobs, :enqueued_at, :datetime
    add_column :solid_queue_jobs, :started_at, :datetime
    add_column :solid_queue_jobs, :completed_at, :datetime
    add_column :solid_queue_jobs, :failed_at, :datetime
    add_column :solid_queue_jobs, :error_message, :text
    add_column :solid_queue_jobs, :retries, :integer, default: 0
  end
end
