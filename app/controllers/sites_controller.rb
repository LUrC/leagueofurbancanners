class SitesController < ApplicationController
    helper_method :sort_column, :sort_direction
    load_and_authorize_resource
  # GET /sites
  # GET /sites.json
  def index
    if params[:set]
      session[:site_filters] = params[:site_filters]
      session[:fruit_ids] = params[:fruit_ids] && params[:fruit_ids].collect { |i| i.to_i }
      session[:zipcode_filters] = params[:zipcode_filters]
    end
    @site_filters = session[:site_filters]
    @fruit_ids = session[:fruit_ids]
    @zipcode_filters = session[:zipcode_filters]

    if (@fruit_ids)
        @sites = Site.has_fruit_in(@fruit_ids).joins(:lurc_contact).order(sort_column + ' ' + sort_direction)
    else
        @sites = Site.joins(:lurc_contact).order(sort_column + ' ' + sort_direction)
    end

    if @site_filters
        @site_filters.each do |site_filter|
            @sites = Site.filter_sites_by(@sites, site_filter);
        end
    end

    if @zipcode_filters
        @sites = Site.filter_sites_by_zipcodes(@sites, @zipcode_filters)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sites }
    end
  end

  def clear_filters
    session[:site_filters] = nil
    session[:fruit_ids] = nil
    session[:zipcode_filters] = nil
    session[:sort] = nil
    session[:direction] = nil
    redirect_to URI(request.referer).path
  end

  def map
    if params[:set]
      session[:site_filters] = params[:site_filters]
      session[:fruit_ids] = params[:fruit_ids] && params[:fruit_ids].collect { |i| i.to_i }
      session[:zipcode_filters] = params[:zipcode_filters]
    end
    @site_filters = session[:site_filters]
    @fruit_ids = session[:fruit_ids]
    @zipcode_filters = session[:zipcode_filters]

    if (@fruit_ids)
        @sites = Site.has_fruit_in(@fruit_ids).joins(:lurc_contact).order(sort_column + ' ' + sort_direction)
    else
        @sites = Site.joins(:lurc_contact).order(sort_column + ' ' + sort_direction)
    end

    if @site_filters
        @site_filters.each do |site_filter|
            @sites = Site.filter_sites_by(@sites, site_filter);
        end
    end

    if @zipcode_filters
        @sites = Site.filter_sites_by_zipcodes(@sites, @zipcode_filters)
    end
    @map_json = @sites.to_gmaps4rails do |site, marker|
        marker.infowindow render_to_string(:partial => "marker_info", :locals => { :site => site })
        marker.json({ :id => site.id, :link => site_url(site) })
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    @site = Site.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @site }
    end
  end

  def coordinate
    if (params[:person_id])
      @person = Person.find(params[:person_id])
      @site = Site.find(params[:id])
      error = ""
      if !@site.lurc_contact_id || @site.lurc_contact_id == 30
        @site.lurc_contact_id = @person.id
      else
        error = 'There is already a coordinator for this site.'
      end
    end
    respond_to do |format|
      if @site.save && @site.lurc_contact_id == @person.id
        format.html { redirect_to @site, notice: 'Congratulations, you are now the coordinator of this site.' }
        format.json { render json: @site, location: @site }
      else
        format.html { redirect_to @site, notice: "There was an error setting you as coordinator. #{error}" }
        format.json { render json: @site.errors }
      end
    end
  end

  # GET /sites/new
  # GET /sites/new.json
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render json: @site, status: :created, location: @site }
      else
        format.html { render action: "new" }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.json
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end

  private
  def sort_column
      session[:sort] = params[:sort] if params[:sort]
      sort = params[:sort] || session[:sort]
      if sort == 'lurc_contact_id'
          "LOWER(people.last_name)"
      elsif Site.column_names.include?(sort)
          "sites.#{sort}"
      else
          "sites.status"
      end
  end

  def sort_direction
    session[:direction] = params[:direction] if params[:direction]
    direction = params[:direction] || session[:direction]
     %w[asc desc].include?(direction) ?  direction : "asc"
  end
end
