set :stage, :production

server "vulpecula.uberspace.de", user: "koelschb", roles: %w{web app db}

set :branch, :master