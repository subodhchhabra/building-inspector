class SheetsController < ApplicationController
  layout "admin"
  before_filter :check_admin! #, :only => [:index, :edit, :destroy]
  # GET /sheets
  # GET /sheets.json
  def index
    # @sheets = Sheet.paginate(:page => params[:page])
    @sheets = Sheet.all(:order => [:layer_id, :map_id])
    @tilesets = Layer.all(:order => :id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sheets }
    end
  end

  # GET /sheets/1
  # GET /sheets/1.json
  def show
    @sheet = Sheet.find(params[:id])

    @tileset = @sheet.layer[:tilejson]
    @tiletype = @sheet.layer[:tileset_type]

    # TODO: allow for admin review of progress in all tasks
    if params[:type] == nil # ALWAYS nil FOR NOW
      params[:type] = "geometry"
    end

    all_polygons = Sheet.progress_for_task(@sheet.id, params[:type])

    fix_poly = []
    yes_poly = []
    no_poly = []
    nil_poly = []

    all_polygons.each do |p|
      if p[:consensus]=="fix"
        fix_poly.push(p.to_geojson)
      elsif p[:consensus]=="yes"
        yes_poly.push(p.to_geojson)
      elsif p[:consensus]=="no"
        no_poly.push(p.to_geojson)
      else
        nil_poly.push(p.to_geojson)
      end
    end

    @map = {}
    @map[:fix_poly] = { :type => "FeatureCollection", :features => fix_poly }
    @map[:no_poly] = { :type => "FeatureCollection", :features => no_poly }
    @map[:yes_poly] = { :type => "FeatureCollection", :features => yes_poly }
    @map[:nil_poly] = { :type => "FeatureCollection", :features => nil_poly }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sheet }
    end
  end

  # GET /sheets/new
  # GET /sheets/new.json
  def new
    @sheet = Sheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sheet }
    end
  end

  # GET /sheets/1/edit
  def edit
    @sheet = Sheet.find(params[:id])
  end

  # POST /sheets
  # POST /sheets.json
  def create
    @sheet = Sheet.new(params[:sheet])

    respond_to do |format|
      if @sheet.save
        format.html { redirect_to @sheet, notice: 'Sheet was successfully created.' }
        format.json { render json: @sheet, status: :created, location: @sheet }
      else
        format.html { render action: "new" }
        format.json { render json: @sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sheets/1
  # PUT /sheets/1.json
  def update
    @sheet = Sheet.find(params[:id])

    respond_to do |format|
      if @sheet.update_attributes(params[:sheet])
        format.html { redirect_to @sheet, notice: 'Sheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sheets/1
  # DELETE /sheets/1.json
  def destroy
    @sheet = Sheet.find(params[:id])
    @sheet.destroy

    respond_to do |format|
      format.html { redirect_to sheets_url }
      format.json { head :no_content }
    end
  end
end
