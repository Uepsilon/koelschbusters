env 'SHELL', '/bin/zsh'

every 1.day, at: '8am' do
  runner 'Comment.team_reminder'
end
