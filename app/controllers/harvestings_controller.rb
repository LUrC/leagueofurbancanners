class HarvestingsController < ApplicationController
    load_and_authorize_resource
  # GET /harvestings
  # GET /harvestings.json
  def index
    @harvestings = Harvesting.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @harvestings }
    end
  end

  # GET /harvestings/1
  # GET /harvestings/1.json
  def show
    @harvesting = Harvesting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @harvesting }
    end
  end

  # GET /harvestings/new
  # GET /harvestings/new.json
  def new
    @harvesting = Harvesting.new 
    @harvesting.harvest_id = params[:harvest_id]
    @harvesting.harvester_id = params[:harvester_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @harvesting }
    end
  end

  # GET /harvestings/1/edit
  def edit
    @harvesting = Harvesting.find(params[:id])
  end

  # POST /harvestings
  # POST /harvestings.json
  def create
    @harvesting = Harvesting.new(params[:harvesting])

    respond_to do |format|
      if @harvesting.save
        format.html do 
          if params[:commit] == "Log Work and Add Another"
            redirect_to new_harvesting_path(harvest_id: @harvesting.harvest_id), notice: "Logged harvester's work successfully."
          else
            redirect_to @harvesting.harvest, notice: "Logged harvester's work successfully."
          end
        end
        format.json { render json: @harvesting, status: :created, location: @harvesting }
      else
        format.html { render action: "new" }
        format.json { render json: @harvesting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /harvestings/1
  # PUT /harvestings/1.json
  def update
    @harvesting = Harvesting.find(params[:id])

    respond_to do |format|
      if @harvesting.update_attributes(params[:harvesting])
        if params[:commit] == "Log Work and Add Another"
          redirect_to new_harvesting_path(harvest_id: @harvesting.harvest_id), notice: "Updated harvester's work successfully."
        else
          redirect_to @harvesting.harvest, notice: "Updated harvester's work successfully."
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @harvesting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /harvestings/1
  # DELETE /harvestings/1.json
  def destroy
    @harvesting = Harvesting.find(params[:id])
    @harvesting.destroy

    respond_to do |format|
      format.html { redirect_to @harvesting.harvest, notice: "Removed harvester's log successfully." }
      format.json { head :no_content }
    end
  end
end
