class HomeController < ApplicationController  
  before_action :user_contact, only: %i[index contact]
  before_action :game_values, only: %i[create_game assessment game dashboard]
  @@question = Hash.new
  @@evaarray = Hash.new
  @@gamearray = Hash.new



  def index
    if params[:filter] == nil
      render "index"
    else
      @params = params[:filter]
    end
  end

  def assessment
  end

  def dashboard
    @greets = greet
    if current_user
      if @usersgame.present?
    if params[:title] != nil
     @gamess = Game.find_by_title(params[:title])
     @ques = Question.where(game_id: @gamess.id)
     @pat = Answer.where(games_id: @gamess.id)
     @patarray = Array.new
     @patlist = Hash.new
     @pat.each do |pat|
      @patarray.push(pat.user_id)
      @patlist.store(pat.question_id, Answer.where(question_id: pat.question_id).ids)
    end
    else
      @gamess = Game.where(user_id: current_user.id)
      @ques = Question.where(game_id: @usersgame.last.id)
      @pat = Answer.where(games_id: @usersgame.last.id)
      @patarray = Array.new
      @patlist = Hash.new
      @pat.each do |pat|
        @patarray.push(pat.user_id)
        @patlist.store(pat.question_id,pat.user_id)
        @patlist.store(pat.question_id, Answer.where(question_id: pat.question_id).ids)
      end
    end
  end
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
          flash.now[:alert] = "Alert"
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
    if current_user
     @user = User.find(current_user.id)
    end
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
    if current_user
      @allgames = Game.all
      @usersgame = Game.where(user_id: current_user.id)
    end
  end

  def contact_params
    params.require(:contact).permit(:mobile, :website, :linkedin, :behance, :github,:instagram)
  end

  def game_params
    params.require(:game).permit(:title, :time, :result)
  end

  
  def question_params
    params.require(:game).permit(:title)
  end

  def greet
    now = Time.now
    today = Date.today.to_time
  
    morning = today.beginning_of_day
    noon = today.noon
    evening = today.change( hour: 17 )
    night = today.change( hour: 20 )
  
    if (morning..noon).cover? now
      'Good Morning,'
    elsif (noon..evening).cover? now
      'Good Afternoon,'
    elsif (evening..night).cover? now
      'Good Evening,'
    end
  end
end
