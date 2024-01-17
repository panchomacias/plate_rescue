class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  def index
    @cart = current_user.cart
    @restaurants = Restaurant.all
    @categories = Category.all.order(:name)
    @city = params[:city]
    if params[:city].present? && params[:food].present?
      @restaurants = Restaurant.includes(:plates).where(plates: { id: Plate.select{|plate| plate.name.downcase.include?(params[:food].downcase)}.pluck(:id) }).select{|restaurant|restaurant.address.downcase.include?(params[:city].downcase)}# de este array de platos solo quiero los ID
    elsif params[:city].present? # "pizza"
      @restaurants = Restaurant.select{|restaurant|restaurant.address.downcase.include?(params[:city].downcase)}# de este array de platos solo quiero los ID
    else
      @restaurants = Restaurant.all
      #@markers = @restaurants.geocoded.map do |restaurant|
       # {
        #  lat: restaurant.latitude,
         # lng: restaurant.longitude,
          #info_window_html: render_to_string(partial: "info_window", locals: {restaurant: restaurant}),
          #marker_html: render_to_string(partial: "marker", locals: {restaurant: restaurant})
        #}
      #end
    end
  end
  def show
    @restaurant = Restaurant.find(params[:id])
    @has_reviewed = @restaurant.reviews.exists?(user: current_user)
  end
  def new
    @restaurant = Restaurant.new
  end
  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id
    if @restaurant.save
      redirect_to my_restaurants_path(@restaurant), notice: 'Restaurant was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    @restaurant = Restaurant.find(params[:id])
  end
  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_params)
      redirect_to my_restaurants_path, notice: 'Restaurant was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.plates.each do |plate|
      plate.category_plates.destroy_all
    end
    @restaurant.destroy
    redirect_to my_restaurants_path, notice: 'Restaurant was successfully destroyed.', status: :see_other
  end

  def my_restaurants
    @restaurants = Restaurant.where(user_id: current_user.id)
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :opening_date, :opening_time, :photo)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

end
