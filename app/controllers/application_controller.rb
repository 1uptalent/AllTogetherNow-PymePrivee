class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from 'User::Forbidden' do
    render :text => "forbidden", :status => :forbidden
  end
end
