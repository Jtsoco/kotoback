class CardsController < ApplicationController

  # before_action :set_book
  def new
    @book = Book.find(params[:book_id])
    @card = Card.new
    authorize @card
  end

  def create
    @book = Book.find(params[:book_id])
    @card = Card.new(card_params)
    @cards = current_user.cards
    @card.book = @book
    authorize @card
    if @card.save
      redirect_to book_path(@book)
    else
      render "new", status: :unprocessable_entity
    end
  end


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
    params.require(:card).permit(:origin_word, :translation_word, :chapter)
  end
end
