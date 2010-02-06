class DashboardsController < ApplicationController
  def show
    @tasks = Task.active
  end
end
