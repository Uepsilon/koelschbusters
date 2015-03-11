# Add Fonts-Path to Assets
Rails.application.config.assets.paths += Dir[Rails.root.join('app', 'assets', 'fonts')]

Rails.application.config.assets.precompile += %w(ckeditor/*)
Rails.application.config.assets.precompile += %w(.svg .eot .woff .ttf)
