class HomeController < ApplicationController
  #before_filter :clear_flash
  def index

  end

  def create_player
    player = Player.new(params[:home])
    if player.save
      render json: player, status: :created
    else
      render json: player.errors, status: :unprocessable_entity

    end
  end

  def player_index
    players = Player.all
    render json: players, status: :ok
  end

  def show_player
    player = Player.find_by_id(params[:id])
    if player
      render json: player, status: :ok
    else
      render json: player, status: :not_found
    end
  end
end