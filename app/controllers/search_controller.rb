class SearchController < ApplicationController
  def actor
    actors = [Actor.where('name like ?', "%#{params[:word]}%")]
    @actors = (actors != nil) ? [actors.first] : []
  end

  def program
    programs = Program.where('title like ?', "%#{ params[:word] }%")
    @programs = (programs != nil) ? [ programs.first ] : []
  end
end
