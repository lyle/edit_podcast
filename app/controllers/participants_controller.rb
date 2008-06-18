class ParticipantsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @participant_pages, @participants = paginate :participants, :per_page => 10
  end

  def show
    @participant = Participant.find(params[:id])
  end

  def new
    @participant = Participant.new
  end

  def create
    @participant = Participant.new(params[:participant])
    if @participant.save
      flash[:notice] = 'Participant was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @participant = Participant.find(params[:id])
  end

  def update
    @participant = Participant.find(params[:id])
    if @participant.update_attributes(params[:participant])
      flash[:notice] = 'Participant was successfully updated.'
      redirect_to :action => 'show', :id => @participant
    else
      render :action => 'edit'
    end
  end

  def destroy
    Participant.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
