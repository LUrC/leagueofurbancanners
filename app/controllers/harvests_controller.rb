class HarvestsController < ApplicationController
    load_and_authorize_resource
  # GET /harvests
  # GET /harvests.json
  def index
    @upcoming_harvests = Harvest.upcoming
    @past_harvests = Harvest.past

    if params[:person_id]
      @person = Person.find(params[:person_id])
      @upcoming_harvests = @person.upcoming_harvestings.map(&:harvest)
      @past_harvests = @person.past_harvestings.map(&:harvest)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @harvests }
    end
  end

  # GET /harvests/1
  # GET /harvests/1.json
  def show
    @harvest = Harvest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @harvest }
    end
  end

  # GET /harvests/new
  # GET /harvests/new.json
  def new
    @harvest = Harvest.new
    @harvest.fruit_tree = FruitTree.find(params[:fruit_tree_id]) if params[:fruit_tree_id]
    @harvest.leader = current_user.person

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @harvest }
    end
  end

  # GET /harvests/1/edit
  def edit
    @harvest = Harvest.find(params[:id])
  end

  #GET /harvests/1/reminder
  def reminder
    @harvest = Harvest.find(params[:id])
  end

  # POST /harvests/1/send_reminder
  def send_reminder
    @harvest = Harvest.find(params[:id])
    @message = params[:message]
    @from = current_user.person
    PersonMailer.harvest_reminder(@harvest, @message, @from).deliver
    respond_to do |format|
        format.html { redirect_to @harvest, notice: 'Reminder was successfully sent.' }
        format.json { render json: @harvest, location: @harvest }
    end
  end

  # POST /harvests
  # POST /harvests.json
  def create
    @harvest = Harvest.new(params[:harvest])

    respond_to do |format|
      if @harvest.save
        format.html { redirect_to @harvest, notice: 'Harvest was successfully created.' }
        format.json { render json: @harvest, status: :created, location: @harvest }
      else
        format.html { render action: "new" }
        format.json { render json: @harvest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /harvests/1
  # PUT /harvests/1.json
  def update
    @harvest = Harvest.find(params[:id])

    respond_to do |format|
      if @harvest.update_attributes(params[:harvest])
        format.html { redirect_to @harvest, notice: 'Harvest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @harvest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /harvests/1
  # DELETE /harvests/1.json
  def destroy
    @harvest = Harvest.find(params[:id])
    @harvest.destroy

    respond_to do |format|
      format.html { redirect_to harvests_url }
      format.json { head :no_content }
    end
  end
end
