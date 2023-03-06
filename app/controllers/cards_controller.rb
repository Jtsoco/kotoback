class CardsController < ApplicationController

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

  private

  def card_params
    params.require(:card).permit(:origin_word, :translation_word)
  end

  def card_params_two
    params.require(:card).permit(:failed_today, :completed_today)
  end
end
