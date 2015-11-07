class HomeController < ApplicationController

  def index
    render :index, layout: 'jumbotron'
  end

end

