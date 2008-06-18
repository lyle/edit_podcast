class QuestionsController < ApplicationController
  include LoginSystem     
  before_filter :login_required

  layout  'application'
  def index
    list
    render_action 'list'
  end

  def list
    @question_pages, @questions = paginate :question, :per_page => 10
        @user = @session[:user]
  end

  def show
    @question = Question.find(@params[:id])
        @user = @session[:user]
  end

  def new
    @question = Question.new
        @user = @session[:user]
  end

  def create
    @question = Question.new(@params[:question])
    @question.user_id = @session[:user]
    if @question.save
      flash['notice'] = 'Question was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @question = Question.find(@params[:id])
        @user = @session[:user]
  end

  def update
    @question = Question.find(@params[:id])
    if @question.update_attributes(@params[:question])
      flash['notice'] = 'Question was successfully updated.'
      redirect_to :action => 'show', :id => @question
    else
      render_action 'edit'
    end
  end

  def destroy
    Question.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
