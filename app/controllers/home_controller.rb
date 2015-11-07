class HomeController < ApplicationController

  def index
    render :index, layout: 'jumbotron'
  end

  def about
  	render :about, layout: 'jumbotron'
  end

  def how_it_works
  	render :how_it_works, layout: 'jumbotron'
  end

  def translate
  end

end

