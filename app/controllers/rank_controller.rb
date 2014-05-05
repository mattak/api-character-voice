class RankController < ApplicationController

  def actor
    limit = 10
    characters = Character
      .select(:program_id,:actor_id)
      .uniq
      .group(:actor_id)
      .order('COUNT(DISTINCT program_id, actor_id) DESC')
      .limit(limit)
      .count
    @ranks = []
    characters.each do |actor_id, count|
      actor = Actor.where('id = ?', actor_id).first
      rank = { count: count, actor: actor }
      @ranks << rank
    end
  end
end
