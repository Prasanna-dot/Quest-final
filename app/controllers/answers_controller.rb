class AnswersController < ApplicationController

  @@evaarray = Hash.new
  @@gamearray = Hash.new

  def index
    if params[:game] != nil
      @@gamearray.store(:pin, params[:game][:pin])
    end
    @game = Game.find_by_pin(@@gamearray[:pin])
    if @game.present?
      if @game.user_id != current_user.id && @game.status == "1" 
        @answer = Answer.where(games_id: @game.id, user_id: current_user.id)
          @gameshow = Question.where(game_id: @game.id)
          @answers = Answer.where(question_id: @gameshow.ids, user_id: current_user.id)
          @gameshow.each do |que|
            @@evaarray.store(que.id, [que.answer, que.choice1, que.choice2, que.choice3])
          end
          @qarr = @@evaarray
          render "index"
      else
        redirect_to "/assessment"
        render :controller => 'posts', :action => 'show', :id => 1
      end
    else
      redirect_to "/assessment"
    end
  end

  def create
    @games = Game.find_by_pin(@@gamearray[:pin])
    @answers = Answer.new(answer_params)
    @que = Question.find(answer_params[:question_id])
    if answer_params[:user_answer] == @que.answer
      @answers[:status] = true
    else
      @answers[:status] = false
    end
    @answers[:games_id] = @games.id
    if @answers.save
      redirect_to "/game"
    end

  end

  private
  
  def answer_params
    params.require(:answer).permit(:question_id, :user_id, :user_answer)
  end
end
