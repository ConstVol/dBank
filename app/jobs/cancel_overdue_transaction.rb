# app/jobs/cancel_overdue_transaction.rb

class CancelOverdueTransaction < Que::Job
  # Default settings for this job. These are optional - without them, jobs
  # will default to priority 100 and run immediately.
  @priority = 10
  @run_at = proc { 2.minute.from_now }

  def run(id)
    # Do stuff.
    transaction = Transaction.find(id)

    ActiveRecord::Base.transaction do
      # Write any changes you'd like to the database.
      transaction.expire! if transaction.may_expire?
      # It's best to destroy the job in the same transaction as any other
      # changes you make. Que will destroy the job for you after the run
      # method if you don't do it yourself, but if your job writes to the
      # DB but doesn't destroy the job in the same transaction, it's
      # possible that the job could be repeated in the event of a crash.
      destroy
    end
  end
end
