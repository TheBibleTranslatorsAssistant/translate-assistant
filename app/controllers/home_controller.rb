class HomeController < ApplicationController

  before_filter :authenticate_user!, only: :translate

  def index
  end

  def about
  end

  def how_it_works
  end

  def translate
  end

end

