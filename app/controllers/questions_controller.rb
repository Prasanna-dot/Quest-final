class QuestionsController < ApplicationController
  @@question = Hash.new
  @@evaarray = Hash.new
  @@gamearray = Hash.new

  def index
    @usergames = Game.all
    @usergames.each do |game|
      if game.title == params[:title] && params[:title] != nil
        @usergame = Game.where(title: params[:title], user_id: current_user.id)
      @@question.store(:id,@usergame.ids[0])
      end
    end

    @questions = Question.where(game_id: @@question[:id], user_id: current_user.id)
    @post = @questions.all
  end

  def create  
    @addque = Question.new(conduct_params)
    @usergame = Game.where(title: params[:title], user_id: current_user.id)
    @addque[:game_id] = @@question[:id]
    @addque[:user_id] = current_user.id
    if @addque.save
      @questions = Question.where(game_id: @@question[:id], user_id: current_user.id)
      redirect_to "/question"
    end
  end

  def delete
    @delque = Question.find(params[:id])
    if @delque.destroy
      redirect_to "/question"
    end
  end

  def show
     render "index"
  end

  private
  def conduct_params
    params.require(:conduct).permit(:question, :answer, :choice1, :choice2, :choice3, :game_id, :user_id)
  end
end
