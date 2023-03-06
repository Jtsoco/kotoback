class CardsController < ApplicationController
  # before_action :set_book
  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    @card.user = current_user
    @cards = current_user.cards
    authorize @card
    if @card.save
      redirect_to :book
    else
      @tab = "new-tab"
      render "new_card", status: :unprocessable_entity
    end
  end

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
