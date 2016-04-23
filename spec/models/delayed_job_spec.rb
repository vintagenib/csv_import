RSpec.describe Delayed::Job do

  context "there are not currently any delayed jobs" do
    it "should be empty of any current jobs" do
      expect(Delayed::Job.all).to be_empty
    end
  end

end
