class PrsController < ApplicationController
  # GET /prs
  # GET /prs.json
  def index
    @prs = Pr.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prs }
    end
  end

  # GET /prs/1
  # GET /prs/1.json
  def show
    @pr = Pr.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pr }
    end
  end

  # GET /prs/new
  # GET /prs/new.json
  def new
    @pr = Pr.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pr }
    end
  end

  # GET /prs/1/edit
  def edit
    @pr = Pr.find(params[:id])
  end

  # POST /prs
  # POST /prs.json
  def create
    @pr = Pr.new(params[:pr])

    respond_to do |format|
      if @pr.save
        format.html { redirect_to @pr, notice: 'Pr was successfully created.' }
        format.json { render json: @pr, status: :created, location: @pr }
      else
        format.html { render action: "new" }
        format.json { render json: @pr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prs/1
  # PUT /prs/1.json
  def update
    @pr = Pr.find(params[:id])

    respond_to do |format|
      if @pr.update_attributes(params[:pr])
        format.html { redirect_to @pr, notice: 'Pr was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prs/1
  # DELETE /prs/1.json
  def destroy
    @pr = Pr.find(params[:id])
    @pr.destroy

    respond_to do |format|
      format.html { redirect_to prs_url }
      format.json { head :ok }
    end
  end
end
