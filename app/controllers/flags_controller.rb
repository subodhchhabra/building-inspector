class FlagsController < ApplicationController
  layout "admin"
  before_filter :check_admin! #, :only => [:index, :edit, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /flags
  # GET /flags.json
  def index
    @flags = Flag.order(sort_column + " " + sort_direction).paginate(:per_page => 100, :page => params[:page])

    @total = Flag.count
    @total_since_v2 = Flag.where("created_at > '2014-04-21'").count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flags }
    end
  end

  # GET /flags/all
  # GET /flags/all.json
  def all
    params[:type] = "address" if !params[:type]
    # below: disabled temporarily
    @flags = [] # Flag.all_as_features(params[:type])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flags }
    end
  end

  # GET /flags/1
  # GET /flags/1.json
  def show
    @flag = Flag.find(params[:id])
    @layer = @flag[:flaggable_type]=="Sheet" ? Sheet.find(@flag[:flaggable_id]).layer : Polygon.find(@flag[:flaggable_id]).sheet.layer
    @tileset = @layer[:tilejson]
    @tiletype = @layer[:tileset_type]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @flag }
    end
  end

  # GET /flags/new
  # GET /flags/new.json
  def new
    @flag = Flag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @flag }
    end
  end

  # GET /flags/1/edit
  def edit
    @flag = Flag.find(params[:id])
  end

  # POST /flags
  # POST /flags.json
  def create
    @flag = Flag.new(params[:flag])

    respond_to do |format|
      if @flag.save
        format.html { redirect_to @flag, notice: 'Flag was successfully created.' }
        format.json { render json: @flag, status: :created, location: @flag }
      else
        format.html { render action: "new" }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /flags/1
  # PUT /flags/1.json
  def update
    @flag = Flag.find(params[:id])

    respond_to do |format|
      if @flag.update_attributes(params[:flag])
        format.html { redirect_to @flag, notice: 'Flag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flags/1
  # DELETE /flags/1.json
  def destroy
    @flag = Flag.find(params[:id])
    @flag.destroy

    respond_to do |format|
      format.html { redirect_to flags_url }
      format.json { head :no_content }
    end
  end

  def stats
    d = Date.today
    period = 12
    @results = []
    (1..period).each do |m|
        past = d - m.months
        first_day = Date.civil(past.year, past.month,1)
        last_day = Date.civil(past.year, past.month,-1)
        flags = Flag.select("COUNT(id) as count, flag_type").where("created_at >= ? AND created_at <= ?", first_day, last_day).group(:flag_type)
        temp = {}
        temp[:period] = past
        temp[:values] = []
        flags.each do |r|
            type = r[:flag_type]
            count = r[:count].to_i
            temp[:values].push({:name=>type,:count=>count})
        end
        @results.push(temp)
    end
    respond_to do |format|
      format.html # stats.html.erb
    end
  end

  private
  
  def sort_column
    Flag.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
