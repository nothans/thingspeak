class CorsController < ApplicationController
  # dummy method that responds with status 200 for CORS preflighting
  def preflight; head :ok; end

end

