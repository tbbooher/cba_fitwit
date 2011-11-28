class FitnessCampsController < ApplicationController
  # GET /fitness_camps
  # GET /fitness_camps.json
  def index
    @fitness_camps = FitnessCamp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fitness_camps }
    end
  end

  # GET /fitness_camps/1
  # GET /fitness_camps/1.json
  def show
    @fitness_camp = FitnessCamp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fitness_camp }
    end
  end

  # GET /fitness_camps/new
  # GET /fitness_camps/new.json
  def new
    @fitness_camp = FitnessCamp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fitness_camp }
    end
  end

  # GET /fitness_camps/1/edit
  def edit
    @fitness_camp = FitnessCamp.find(params[:id])
  end

  # POST /fitness_camps
  # POST /fitness_camps.json
  def create
    @fitness_camp = FitnessCamp.new(params[:fitness_camp])

    respond_to do |format|
      if @fitness_camp.save
        format.html { redirect_to @fitness_camp, notice: 'Fitness camp was successfully created.' }
        format.json { render json: @fitness_camp, status: :created, location: @fitness_camp }
      else
        format.html { render action: "new" }
        format.json { render json: @fitness_camp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fitness_camps/1
  # PUT /fitness_camps/1.json
  def update
    @fitness_camp = FitnessCamp.find(params[:id])

    respond_to do |format|
      if @fitness_camp.update_attributes(params[:fitness_camp])
        format.html { redirect_to @fitness_camp, notice: 'Fitness camp was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @fitness_camp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fitness_camps/1
  # DELETE /fitness_camps/1.json
  def destroy
    @fitness_camp = FitnessCamp.find(params[:id])
    @fitness_camp.destroy

    respond_to do |format|
      format.html { redirect_to fitness_camps_url }
      format.json { head :ok }
    end
  end
end
