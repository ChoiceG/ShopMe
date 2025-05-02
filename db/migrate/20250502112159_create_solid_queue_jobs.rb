class CreateSolidQueueJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :job_class
      t.text :args
      t.timestamps
    end
  end
end
