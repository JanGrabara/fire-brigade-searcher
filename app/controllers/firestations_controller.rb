class FirestationsController < ApplicationController
  def show
    @firestations = []
    @search = Search.new
    @search.city = params[:city]
    @search.street = params[:street]
    @search.radius = params[:radius]

    if @search.valid?
      @firestations = Firestation.near(@search.create_query, @search.radius, units: :km).order('distance')
    end
    end
end
