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
    if params[:card][:completed_today]
      @card.update(card_params_two)
    else
      @card.update(card_params)
    end
    authorize @card
    respond_to do |format|
      format.html { redirect_to book_path(@card.book) }
      format.json { head :ok }
    end
  end

  def destroy
    @card = Card.find(params[:id])
    authorize @card
    @card.destroy
    redirect_to book_path, status: :see_other
  end

  private

  def card_params
    params.require(:card).permit(:origin_word, :translation_word, :chapter)
  end

  def card_params_two
    params.require(:card).permit(:failed_today, :completed_today)
  end
end
