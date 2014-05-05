class RootController < ApplicationController
  def index
    @program_count   = Program.all.count
    @character_count = Character.all.count
    @actor_count     = Actor.all.count
  end
end
