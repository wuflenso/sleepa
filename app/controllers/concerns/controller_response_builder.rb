module ControllerResponseBuilder
  extend ActiveSupport::Concern

  private

  def build_paginated_success_response(response)
    {
      data: response.first,
      meta: {
        count: response.second,
        limit: params[:limit] || 10,
        offset: params[:offset] || 0
      }
    }
  end

  def build_success_response(response)
    {
      data: response,
      meta: {}
    }
  end
end
