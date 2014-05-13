class PeopleController < ApplicationController
    load_and_authorize_resource
  # GET /people
  # GET /people.json
  def index
    @people = Person.order(:last_name, :first_name).paginate(:per_page => 50, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  def merge
      @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render json: @person, status: :created, location: @person }
      else
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def commit_merge
      @person = Person.find(params[:id])
      @other_person = Person.find(params[:other_person_id])
      respond_to do |format|
        if @person.merge_in(@other_person)
          format.html { redirect_to @person, notice: 'Person was succesfully merged.' }
          format.json { head :no_content }
        else
          format.html { render action: "merge"}
          format.json { render json: @person.errors, status: :unprocessable_entity}
        end
      end
  end

  def site_chooser
    @person = Person.find(params[:id]);
    # if (!@person.lat || !@person.lon)
    #   @person.geocode
    #   @person.save
    # end
    if (params[:address])
      @address = params[:address]
      coords = Geocoder.coordinates(params[:address])
      @choices = Site.closest_sites(coords[0], coords[1], 15)
      @mapped = @choices
    elsif (!@person.lat || !@person.lon || @person.city.blank?)
      s = Site.first
      @address = "Cambridge, MA 02139"
      @choices = Site.closest_sites(s.lat, s.lon, 15);
      @mapped = @choices
    else
      @address = @person.address
      @choices = Site.closest_sites(@person.lat, @person.lon, 15);
      @mapped = [@person] + @choices
    end
    @map_json = @mapped.to_gmaps4rails do |item, marker|
      if item.is_a? Site
        marker.infowindow render_to_string(:partial => "sites/marker_info", :locals => { :site => item })
        marker.json({ :id => item.id, :link => site_path(item) })
      else
        marker.infowindow render_to_string(:partial => "people/marker_info", :locals => { :person => item })
        marker.json({ :id => item.id, :link => person_path(item) })
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end
end
