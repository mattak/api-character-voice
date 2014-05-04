class SearchController < ApplicationController
  def actor
    @actors = [Actor.find_by(name: params[:word])]
  end

  def program
    programs = Program.where('title like ?', "%#{ params[:word] }%")
    @programs = (programs != nil) ? [ programs.first ] : []
  end
end
