class WelcomeController < ApplicationController
  def index
    render plain: "Hello from Rails on Render!"
  end
end
