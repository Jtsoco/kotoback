class CardsController < ApplicationController
  # before_action :set_book

  def edit
    # @book = Book.find(params[:book_id])
    @card = Card.find(params[:id])
    authorize @card
  end

  def update
    @card = Card.find(params[:id])
    @card.update(card_params)
    authorize @card
    redirect_to cards_path(@card)
  end

  private

  # def set_book
  #   @book = Book.find(params[:book_id])
  # end

  def card_params
    params.require(:card).permit(:origin_word, :translation_word)
  end
end
