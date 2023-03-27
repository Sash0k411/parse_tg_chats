# frozen_string_literal: true

namespace :bot do
  task start: [:environment] do
    Bot.listen
  end
end
