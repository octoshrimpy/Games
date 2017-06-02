class PlayerController < ApplicationController
  def id
  end

  def hand
    5.times do
      rbhand[] << "#{draw}.png"
    end
  end
  helper_method :hand

  def create
  end

  def read
  end

  def update
  end

  def destroy
  end
end
