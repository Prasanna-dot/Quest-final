# frozen_string_literal: true

class AnswersController < ApplicationController
  @@evaarray = {}
  @@gamearray = {}

  def index
    @@gamearray.store(:pin, params[:game][:pin]) unless params[:game].nil?
    @game = Game.find_by_pin(@@gamearray[:pin])
    if @game.present?
      if @game.user_id != current_user.id && @game.status == '1'
        @answer = Answer.where(games_id: @game.id, user_id: current_user.id)
        @gameshow = Question.where(game_id: @game.id)
        @answers = Answer.where(question_id: @gameshow.ids, user_id: current_user.id)
        @gameshow.each do |que|
          @@evaarray.store(que.id, [que.answer, que.choice1, que.choice2, que.choice3])
        end
        @qarr = @@evaarray
        render 'index'
      else
        redirect_to '/assessment'
      end
    else
      redirect_to '/assessment'
    end
  end

  def create
    @games = Game.find_by_pin(@@gamearray[:pin])
    @answers = Answer.new(answer_params)
    @que = Question.find(answer_params[:question_id])
    @answers[:status] = answer_params[:user_answer] == @que.answer
    @answers[:games_id] = @games.id
    redirect_to '/game' if @answers.save
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :user_id, :user_answer)
  end
end
