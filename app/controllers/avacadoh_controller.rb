class Avacadoh::AvacadohController < ApplicationController
  #before_filter :clear_flash
  def avacadoh

  end

  def create_player_sheet
    player_sheet =  AvacadohPlayerSheet.new(params[:player_sheet])
    if player_sheet.save
      render :json => player_sheet, status: :created
    else
      render :json => player_sheet.errors, status: :unprocessable_entity
    end
  end

  def show_player_sheet
    player_sheet =  AvacadohPlayerSheet.find_by_id(params[:id])
    if player_sheet
      render :json => player_sheet, status: :ok
    else
      render :json => player_sheet, status: :not_found
    end
  end

  def create_player
    player = AvacadohUser.new(params[:player])
    if player.save
      render json: player, status: :created
    else
      render json: player.errors, status: :unprocessable_entity

    end
  end

  def show_player
    player = AvacadohUser.find_by_id(params[:id])
    if player
      render json: player, status: :ok
    else
      render json: player, status: :not_found
    end
  end
end