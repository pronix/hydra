require 'spec_helper'

describe JobLogging do
  before(:each) do
    @valid_attributes = {
      :task_id => 1,
      :job => "value for job",
      :startup => Time.now,
      :stop_time => Time.now,
      :comment => "value for comment"
    }
  end

  it "should create a new instance given valid attributes" do
    JobLogging.create!(@valid_attributes)
  end
end
