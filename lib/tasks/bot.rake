namespace :bot do
  task start: [:environment] do
    Bot.listen
  end
end