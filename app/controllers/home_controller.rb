class HomeController < ApplicationController
  def index
    @home = Home.find(1)
  end
  def show
    @contact = Contact.find(1)
  end
end
