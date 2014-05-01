class SearchController < ApplicationController
  def actor
    @actors = [Actor.find_by(name: params[:word])]
  end
end
