class CardsController < ApplicationController

  def edit
    @card = Card.find(params[:id])
    authorize @card
  end

  def update
    @card = Card.find(params[:id])
    @card.update(card_params)
    authorize @card
    redirect_to book_path(@card.book)
  end

  private

  def card_params
    params.require(:card).permit(:origin_word, :translation_word)
  end
end
