class HomeController < ApplicationController  
  before_action :user_contact, only: %i[index contact]
  before_action :game_values, only: %i[create_game assessment]
  @@question = Hash.new
  
  def index
    if params[:filter] == nil
      render "index"
    else
      @params = params[:filter]
    end
  end

  def assessment
  end

  def question
    @usergame = Game.where(title: params[:title], user_id: current_user)
    @@question.store(:id,@usergame.ids[0])
  end

  def add_question
    @addque = Question.new(conduct_params)
    @usergame = Game.where(title: params[:title], user_id: current_user)
    @addque[:game_id] = @@question[:id]
    if @addque.save
      render "question"
    end
  end

  def contact
    if @usercontacts.present?
      if contact_params[:mobile] == "" && contact_params[:website] == "" && contact_params[:linkedin] == "" && contact_params[:behance] == "" && contact_params[:instagram] == ""
        if @usercontacts.destroy
          redirect_to "/settings"
        end
      else      
        @usercontacts.update(contact_params)
        if @usercontacts.save
          redirect_to "/settings"
        end
      end
    else
      @usercon = UserContact.new(contact_params)
      @usercon[:user_id] = current_user.id
      if @usercon.save
        redirect_to "/settings"
      end
    end
  end

  def create_game
    if @allgames.present?
      @usergame = Game.where(title: game_params[:title], user_id: current_user)
    if @usergame.present?
          flash.now[:alert] = "Title already exist"
          render "assessment"
        else
          @game = Game.new(game_params)
          @game[:status] = false
          @game[:pin] = rand.to_s[2..7]
          @game[:user_id] = current_user.id
          if @game.save
            redirect_to "/assessment"
          end
      end
    else
    @game = Game.new(game_params)
    @game[:status] = false
    @game[:pin] = rand.to_s[2..7]
    @game[:user_id] = current_user.id
    if @game.save
    redirect_to "/assessment"
    end
  end
  end
  
  def start_game
    @game = Game.where(user_id: current_user,title: params[:title])
    if @game.update(:status => true)
      redirect_to "/assessment"
      end
  end

  def stop_game
    @game = Game.where(user_id: current_user,title: params[:title])
    if @game.update(:status => false)
      redirect_to "/assessment"
      end
  end

  private
  def set_user
    @user = User.find(current_user.id)
  end

  def user_contact
    @usercontact = UserContact.all
    if @usercontact.present? && current_user
      @usercontacts = UserContact.find_by_user_id(current_user.id)
        if @usercontacts.present?
          @usermobile = @usercontacts.mobile
          @userwebsite = @usercontacts.website
          @userlinkedin = @usercontacts.linkedin
          @userbehance = @usercontacts.behance
          @usergithub = @usercontacts.github
          @userinstagram = @usercontacts.instagram
        end
    end
  end
  
  def game_values
    @allgames = Game.all
    @usersgame = Game.where(user_id: current_user)
  end

  def contact_params
    params.require(:contact).permit(:mobile, :website, :linkedin, :behance, :github,:instagram)
  end

  def game_params
    params.require(:game).permit(:title)
  end

  
  def question_params
    params.require(:game).permit(:title)
  end

  def conduct_params
    params.require(:conduct).permit(:question, :answer, :choice1, :choice2, :choice3, :game_id)
  end
end
