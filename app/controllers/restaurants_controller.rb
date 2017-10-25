class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.all
  end

  def new
    if current_user.restaurant
      flash[:notice] = "You have already created a restaurant"
      redirect_to admin_path
    else
      @restaurant = Restaurant.new
    end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id
    if @restaurant.save
      flash[:notice] = "#{@restaurant.name} has been created"
      redirect_to admin_path
    else
      flash[:alert] = "There are mistakes in your submission"
      render :new
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    @restaurant.open_hour = @restaurant.open_hour.strftime('%I:%M%p')
    @restaurant.close_hour = @restaurant.close_hour.strftime('%I:%M%p')
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.name = params[:restaurant][:name]
    @restaurant.address = params[:restaurant][:address]
    @restaurant.city = params[:restaurant][:city]
    @restaurant.price_range = params[:restaurant][:price_range]
    @restaurant.total_seats = params[:restaurant][:total_seats]
    @restaurant.open_hour = params[:restaurant][:open_hour]
    @restaurant.close_hour = params[:restaurant][:close_hour]
    @restaurant.description = params[:restaurant][:description]


    if @restaurant.save
      redirect_to admin_path
    else
      flash[:alert] = "There are mistakes in your submission"
      render :edit
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :city, :price_range, :total_seats, :open_hour, :close_hour, :description)
  end
end
