require 'spec_helper'

describe "home/index.html.erb" do
  
  it "should have a sign up link" do
    render
    assert_select 'a[href=?]', /#{new_user_registration_path}/, :text => /sign up/i
  end

  it "should have a log in link" do
    render
    assert_select 'a[href=?]', /#{sign_in_path}/, :text => /log in/i
  end
end
