class AnswersController < ApplicationController

  layout  'application'
  def index
    list
    render_action 'list'
  end

  def list
    @answer_pages, @answers = paginate :answer, :per_page => 10
  end

  def show
    @answer = Answer.find(@params[:id])
  end

  def new
    @answer = Answer.new
    @answer.question_id = (@params[:question_id])
    @question = Question.find(@params[:question_id])
  end

  def create
    @answer = Answer.new(@params[:answer])
    @answer.user_id = @session[:user]
    if @answer.save
      flash['notice'] = 'Answer was successfully created.'
      redirect_to :controller => 'questions', :action => 'show', :id => @answer.question
    else
      render_action 'new'
    end
  end

  def edit
    @answer = Answer.find(@params[:id])
    @question = Question.find(@answer.question_id)
  end

  def update
    @answer = Answer.find(@params[:id])
    if @answer.update_attributes(@params[:answer])
      flash['notice'] = 'Answer was successfully updated.'
      redirect_to :controller => 'questions', :action => 'show', :id => @answer.question
    else
      render_action 'edit'
    end
  end

  def destroy
    Answer.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
