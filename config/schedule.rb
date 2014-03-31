env ‘SHELL’, ‘/bin/zsh’

every 1.day, at: '8am' do
  runner "NewsComment.team_reminder"
end