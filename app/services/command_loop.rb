# frozen_string_literal: true

class CommandLoop
  def process_task(task)
    Telegram::Task.find_each do |command|
      command.update(status: :in_progress)
      CommandJob.perform_later(task)
    end
  end
end
