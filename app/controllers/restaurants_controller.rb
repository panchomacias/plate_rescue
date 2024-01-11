class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.all
    if params[:city].present? && params[:food].present?
      @restaurants = Restaurant.includes(:plates).where(plates: { id: Plate.select{|plate| plate.name.downcase.include?(params[:food].downcase)}.pluck(:id) }).select{|restaurant|restaurant.address.downcase.include?(params[:city].downcase)}# de este array de platos solo quiero los ID
    elsif params[:city].present? # "pizza"
        @restaurants = Restaurant.select{|restaurant|restaurant.address.downcase.include?(params[:city].downcase)}# de este array de platos solo quiero los ID
    else
      @restaurants = Restaurant.all
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id

    if @restaurant.save
      redirect_to restaurant_path(@restaurant), notice: 'Restaurant was successfully created.'
    else
      ender :new, status: :unprocessable_entity
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_path(@restaurant), notice: 'Restaurant was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to restaurants_path, notice: 'Restaurant was successfully destroyed.'
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :opening_date, :opening_time, :photo)
  end

end
